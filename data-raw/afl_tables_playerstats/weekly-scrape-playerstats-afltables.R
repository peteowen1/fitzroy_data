# Script to get data from afltables
library(fitzRoy)
library(dplyr)
library(readr)

# Run function on range of id's ----
# I've got a list of ID's that I scraped in a file called id_data.rda
end_year <- as.numeric(format(Sys.Date(), "%Y"))
seasons <- 1897:(end_year - 1)

#afldata_old <- fetch_player_stats_afltables(seasons)

cli::cli_progress_step("Fetching afltables player stats")
afldata_new <- fetch_player_stats_afltables(1897:end_year, 
                                            rescrape = TRUE, 
                                            rescrape_start_season = (end_year - 1))

#afldata <- bind_rows(afldata_old, afldata_new)

# remove duplicate games if exist
cli::cli_progress_step("Tidying afltables player stats")
afldata <- distinct(afldata_new)

# afldata %>%
#   select(Season, Round, Date, First.name , Surname , ID , Playing.for) %>%
#   filter(First.name == "Eddie", Surname == "Ford") 
# 
# afldata %>%
#   select(Season, Round, Date, First.name , Surname , ID , Playing.for) %>%
#   filter(First.name == "Brayden", Surname == "Cook")

#afldata %>%
#  filter(Season == 2022) %>%
#  mutate(Round = as.integer((Round))) %>%
#  group_by(Season, Round) %>%
#  summarise(games = n_distinct(Home.team)) %>%
#  arrange(Round) %>%
#  print(n = Inf)

# Write ids file
id <- afldata %>%
  ungroup() %>%
  mutate(
    Player = paste(First.name, Surname),
    Team = Playing.for
  ) %>%
  select(Season, Player, ID, Team) %>%
  distinct()

cli::cli_progress_step("Saving afltables player stats")
write_csv(id, here::here("data-raw", "afl_tables_playerstats", "player_ids.csv"))

# Write data using devtools
#devtools::use_data(player_stats, overwrite = TRUE)
write_rds(afldata, here::here("data-raw", "afl_tables_playerstats", "afldata.rds"))
save(afldata, file = here::here("data-raw", "afl_tables_playerstats", "afldata.rda"))


#x <- readRDS(here::here("data-raw", "afl_tables_playerstats", "afldata.rds"))

