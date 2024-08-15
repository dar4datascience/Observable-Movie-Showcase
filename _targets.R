# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble",
               "reactablefmtr",
               "reactable",
               "purrr",
               "httr2",
               "janitor",
               "fs",
               "dplyr",
               "readr"), # Packages that your targets need for their tasks.
  cue = tar_cue(mode = "always")
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # Pipelines that take a long time to run may benefit from
  # optional distributed computing. To use this capability
  # in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  #   controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package.
  # For the cloud, see plugin packages like {crew.aws.batch}.
  # The following example is a controller for Sun Grid Engine (SGE).
  #
  #   controller = crew.cluster::crew_controller_sge(
  #     # Number of workers that the pipeline can scale up to:
  #     workers = 10,
  #     # It is recommended to set an idle time so workers can shut themselves
  #     # down if they are not running tasks.
  #     seconds_idle = 120,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.2".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.
# step 1: fs to get list of updated movies to show case
# step 2: reactable to show case the movies with embed movies
# step 3: deploy to github pages
showcase_path_tanda2 <- "/run/user/1000/gvfs/smb-share:server=desktop-eknjrcs,share=bigelements/Rafa Processed/Segunda Tanda"

showcase_path_tanda1 <- "/run/user/1000/gvfs/smb-share:server=desktop-eknjrcs,share=bigelements/Rafa Processed/Primera Tanda"

omdb_api <- Sys.getenv("OMDb_key")

# Replace the target list below with your own:
list(
  tar_target(
    name = showcase_movies_tanda1,
    command = query_movies_2_showcase(showcase_path_tanda1)
  ),
  tar_target(
    name = movies_metadata_tanda1,
    command = search_all_movies_metadata(showcase_movies_tanda1, omdb_api)
  ),
  tar_target(
    name = showcase_movies_tanda2,
    command = query_movies_2_showcase(showcase_path_tanda2)
  ),
  tar_target(
    name = movies_metadata_tanda2,
    command = search_all_movies_metadata(showcase_movies_tanda2, omdb_api)
  ),
  tar_quarto(
    name = render_observable,
    path = "movie_showcaser.qmd"
  )
)
