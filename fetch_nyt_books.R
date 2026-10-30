# DATA 607 Week 9: NYT hardcover fiction bestseller list
stopifnot(all(vapply(c("httr","jsonlite","DBI","RSQLite"),requireNamespace,logical(1),quietly=TRUE)))
key <- Sys.getenv("NYT_API_KEY")
if (!nzchar(key)) stop("Missing NYT_API_KEY in ~/.Renviron. Add it privately and restart RStudio.")
endpoint <- "https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json"
resp <- httr::GET(endpoint,query=list("api-key"=key),httr::timeout(30))
if(httr::status_code(resp)!=200) stop("NYT API returned HTTP ",httr::status_code(resp))
raw_json <- httr::content(resp,"text",encoding="UTF-8")
j <- jsonlite::fromJSON(raw_json,simplifyVector=FALSE)
if(!identical(j$status,"OK") || is.null(j$results$books) || !length(j$results$books)) stop("No valid books returned")
scalar <- function(x) if(is.null(x)||!length(x)) NA_character_ else as.character(x[[1]])
integer <- function(x) suppressWarnings(as.integer(scalar(x)))
stamp <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ",tz="UTC")
d <- do.call(rbind,lapply(j$results$books,function(b) data.frame(
 list_name=scalar(j$results$list_name),published_date=scalar(j$results$published_date),
 rank=integer(b$rank),rank_last_week=integer(b$rank_last_week),
 weeks_on_list=integer(b$weeks_on_list),title=scalar(b$title),
 author=scalar(b$author),publisher=scalar(b$publisher),
 primary_isbn13=scalar(b$primary_isbn13),fetched_at_utc=stamp)))
stopifnot(!anyNA(d$rank),!anyNA(d$title),!anyDuplicated(d[c("list_name","published_date","rank")]))
con <- DBI::dbConnect(RSQLite::SQLite(),"data/nyt_books.sqlite")
on.exit(DBI::dbDisconnect(con),add=TRUE)
DBI::dbWithTransaction(con,{
 DBI::dbExecute(con,"DELETE FROM bestseller_books WHERE list_name=? AND published_date=?",params=list(d$list_name[1],d$published_date[1]))
 DBI::dbWriteTable(con,"bestseller_books",d,append=TRUE)
 DBI::dbExecute(con,"INSERT INTO download_log (fetched_at_utc,endpoint,list_name,published_date,records) VALUES (?,?,?,?,?)",
 params=list(stamp,endpoint,d$list_name[1],d$published_date[1],nrow(d)))
})
writeLines(raw_json, "data/nyt_hardcover_fiction_raw.json", useBytes=TRUE)
utils::write.csv(d,"data/nyt_hardcover_fiction.csv",row.names=FALSE,na="")
cat("Downloaded",nrow(d),"books. Published date:",d$published_date[1],"\n")
print(d[,c("rank","title","author","weeks_on_list")],row.names=FALSE)
