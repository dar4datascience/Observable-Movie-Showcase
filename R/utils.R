
#' @export
tbl_movies_found <- function(movies_found) {
  movies_found |>
    dplyr::select(title, year, plot, poster) |>
    reactable(
      theme = fivethirtyeight(centered = TRUE),
      selection = "single",
      onClick = "select",
      striped = TRUE,
      pagination = FALSE,
      defaultColDef = colDef(align = 'center'),
      columns = list(
        poster = colDef(
          name = 'Poster',
          maxWidth = 200,
          cell = embed_img(movies_found$poster,
                           height = 200,
                           width = 235,
                           horizontal_align = 'center')
        ),
        title = colDef(maxWidth = 150, name = 'Movie'),
        year = colDef(maxWidth = 50,
                      name = 'Released'),
        plot = colDef(minWidth = 150,
                      name = 'Plot')
      )
    )
}

#' @export
query_movies_2_showcase <- function(path){
  # get all files in the directory
  files <- fs::dir_ls(path)
  base_names <- fs::path_file(files)
  # from base names remove the year component. title is like Æon Flux (2005), remove the (2005) and remove white spaces
  omdb_names <- gsub("\\(.*\\)", "", base_names)
  # trim leading and trailing white spaces
  omdb_names <- trimws(omdb_names)

  # filter only the files that contain the word 'movies'
  files_db <- tibble(
    file_path = files,
    base_name = base_names,
    ombd_name = omdb_names
  )

  return(files_db)
}


#' @export
save_movies_metadata <- function(movies_metadata){
  readr::write_csv(movies_metadata, "movies_metadata.csv",
                   append = FALSE)
}
