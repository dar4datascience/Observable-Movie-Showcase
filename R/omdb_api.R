
# Function to get movie data from OMDB API
#' @export
search_movie_data <- function(movie_name, api){
  # transform spaces in movie name to '+'
  movie_name <- gsub(" ", "+", movie_name)

  # cli inform movie name being queried
  cli::cli_inform(cat("Searching for movie: ", movie_name, "\n"))

  movie_url <- paste0("http://www.omdbapi.com/?s=", movie_name, "&apikey=", api)

  #print(movie_url)

  response <- request(movie_url) |>
    req_perform() |>
    resp_body_json() |>
    pluck("Search") |>
    map(
      ~ tibble(
        title = .x$Title,
        year = .x$Year,
        poster = .x$Poster
      )
    ) |>
    list_rbind() |>
    #remove movies with no poster
    filter(poster != 'N/A')

  return(response)

}

# using search_movie_data make a movie that takes a vector of movie names and search them all and returns the result sin datafrma unified
#' @export
search_all_movies_metadata <- function(movies_df, api){
  movies <- movies_df$ombd_name
  movies_data <- map(movies, ~ query_movie_data(.x, api))
  movies_data <- list_rbind(movies_data)
  return(movies_data)
}

# this requieres precise name. the title from the seached movie data
#' @export
query_movie_data <- function(movie_name, api){
  # transform spaces in movie name to '+'
  movie_name <- gsub(" ", "+", movie_name)

  # cli inform movie name being queried
  cli::cli_inform(cat("Searching for movie: ", movie_name, "\n"))


  movie_url <- paste0("http://www.omdbapi.com/?t=", movie_name, "&apikey=", api)

  #print(movie_url)

  response <- request(movie_url) |>
    req_perform() |>
    resp_body_json()

  #print(response)

  cleaned_response <- tibble(
        title = response$Title,
        year = response$Year,
        poster = response$Poster,
        plot = response$Plot
      ) |>
    #remove movies with no poster
    filter(poster != 'N/A')

  return(cleaned_response)

}

# function that takes a list of movie data and extract desird information: title, year of release
#' @export
fetch_key_movie_attributes <- function(movie_data){

  movie_title <- movie_data$title
  movie_year <- movie_data$year
  movie_release_date <- movie_data$released
  movie_genre <- movie_data$genre
  movie_plot <- movie_data$plot
  movie_poster <- movie_data$poster
  movie_country <- movie_data$country
  movie_box_office <- movie_data$box_office
  movie_imbd_rating <- movie_data$imdb_rating
  movie_imbd_votes <- movie_data$imdb_votes
  movie_rated <- movie_data$rated

  # make a ddataframe
  movie_attributes <-
    data.frame(
      title = movie_title,
      year = movie_year,
      released = movie_release_date,
      rated = movie_rated,
      genre = movie_genre,
      plot = movie_plot,
      poster = movie_poster,
      country = movie_country,
      box_office = movie_box_office,
      imdb_rating = movie_imbd_rating,
      imdb_votes = movie_imbd_votes
    )

  return(movie_attributes)
}

