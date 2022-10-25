####################################################################
################## VOLUME CALCULATIONS FUNCTION ####################
####################################################################

vol_func <- function(diameter, height, width, shape, counts) {
  pi= 3.1415
  volume = 0
  if(grepl("cone1", shape, ignore.case = TRUE)){
    volume = (pi/12) * diameter^2 * height
  }
  if(grepl("cones2", shape, ignore.case = TRUE)){
    volume = 2*(pi/12) * diameter^2 * height
  }
  if(grepl("sph", shape, ignore.case = TRUE)){
    volume = (pi/6) * diameter^3
  } 
  if(grepl("prosph", shape, ignore.case = TRUE)){
    volume = (pi/6) * diameter^2 * height
  }
  if(grepl("cyl", shape, ignore.case = TRUE)){
    volume = (pi/4) * diameter^2 * height
  }
  if(grepl("ellips", shape, ignore.case = TRUE)){
    volume = (pi/6) * diameter * height * width
  }
  if(grepl("recbox", shape, ignore.case = TRUE)){
    volume = diameter * height * width
  }
  if(grepl("prisell", shape, ignore.case = TRUE)){
    volume = (pi/4) * diameter * height * width
  }
  if(grepl("prispar", shape, ignore.case = TRUE)){
    volume = 0.5 * diameter * height * width
  }
  if(volume == 0){
    return(NA)
  } else{
    return(volume * counts)
  }
}