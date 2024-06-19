
#' @export
tbl_movies_found <- function(movies_found) {
  movies_found |>
    reactable(
      theme = fivethirtyeight(centered = TRUE),
      selection = "single",
      onClick = "select",
      striped = TRUE,
      defaultColDef = colDef(align = 'center'),
      columns = list(
        team_logo_espn = colDef(show = FALSE),
        title = colDef(maxWidth = 200, name = 'Movie'),
        year = colDef(name = 'Released'),
        poster = colDef(
          name = 'Poster',
          minWidth = 150,
          cell = embed_img(movies_found$poster,
                           height = 100,
                           width = 135,
                           horizontal_align = 'center')
        )
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
