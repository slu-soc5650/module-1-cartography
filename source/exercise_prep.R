library(sf)
library(tigris)
library(dplyr)

stl <- counties(state = 29) %>%
  filter(GEOID == "29510") %>%
  select(GEOID, NAMELSAD)

stl <- st_transform(stl, crs = 26915)

st_write(stl, "data/STL_BOUNDARY_City.geojson", delete_dsn = TRUE)

nhood <- st_read(here::here("data", "source_data", "STL_DEMOGRAPHICS_Nhoods", "STL_DEMOGRAPHICS_Nhoods.shp"))

nhood %>%
  mutate(AREA = as.numeric(st_area(geometry))) %>%
  mutate(sq_km = measurements::conv_unit(AREA, from = "m2", to = "km2")) %>%
  mutate(pop50_den = pop50/sq_km) %>%
  select(NHD_NUM, NHD_NAME, pop50, pop50_den, sq_km, geometry) -> nhood

st_write(nhood, "data/exercise_data/STL_DEMOGRAPHICS_Nhoods/STL_DEMOGRAPHICS_Nhoods.shp", delete_dsn = TRUE)

historic <- st_read(here::here("data", "source_data", "STL_HISTORICAL_Districts", "STL_HISTORICAL_Districts.shp"))
historic <- st_transform(historic, crs = 26915)

historic <- select(historic, DISNAME, DIS_TYPE, DISNUM, DIS_DATE)
st_write(historic, "data/exercise_data/STL_HISTORICAL_Districts/STL_HISTORICAL_Districts.shp", delete_dsn = TRUE)
