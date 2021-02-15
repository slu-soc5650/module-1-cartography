library(sf)
library(tigris)
library(dplyr)
library(tidycensus)

stl_water <- area_water(state = 29, county = 510) %>%
  st_transform(crs = 26915) %>%
  select(HYDROID, FULLNAME)

st_write(stl_water, "data/lab_data/STL_HYDRO_AreaWater.geojson", delete_dsn = TRUE)

il_water <- st_read(here::here("data", "source_data", "IL_HYDRO_Mississippi.geojson")) %>%
  st_transform(crs = 26915)

st_write(il_water, "data/lab_data/IL_HYDRO_Mississippi.geojson", delete_dsn = TRUE) 

highway <- st_read(here::here("data", "source_data", "STL_TRANS_PrimaryRoads", "STL_TRANS_PrimaryRoads.shp")) %>%
  st_transform(crs = 26915)

st_write(highway, "data/lab_data/STL_TRANS_PrimaryRoads/STL_TRANS_PrimaryRoads.shp", delete_dsn = TRUE) 

house <- get_decennial(geography = "tract", variables = c("H014001", "H014002"), state = 29, county = 510, output = "wide", geometry = TRUE) %>%
  rename(
    total_households = H014001,
    owner_occupied = H014002
  ) %>%
  mutate(pct_owner_occupied = owner_occupied/total_households*100) %>%
  select(GEOID, NAME, total_households, owner_occupied, pct_owner_occupied, geometry)  %>%
  st_transform(crs = 26915)

st_write(house, "data/lab_data/STL_HOUSING_OwnerOccupied.geojson", delete_dsn = TRUE) 
