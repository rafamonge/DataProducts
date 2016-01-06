library(shiny)
fluidPage( 
  navbarPage(
    tabPanel("Title", "Costa Rica Real Estate "), 
    tabPanel("About",
             h2("If you are just interested in looking at the data, go to the next Tab!"),
             h2("Goal"),
             p("It's goal is to show the median price per squater meter for Costa Rica's regions and subregions (states, provinces etc. for other countries). This would allow people to identify which regions are the most or least expensieve. The goal is to to have a map broken by regions in which the color represents the mean Price by M2. It was created for John Hopkins Data Science specialization."),
             h2("Using the application"),
             p("This application has 3 parameters: Weight, upper and lower bound. The default values work well and generally reflect what I would expect as a citizen from Costa Rica (i.e. the most expensieve regions are around San Jose, Guanacaste and Jaco). Nevertheless, you can still play with the parameters:"),
             h3("Weight"),
             p("The price by M2  is calculated through the following formula: PriceByM2 = Price  / (Total Square Meters of Terrain * Weight + Total Square Meters of Construction). The idea is that an square meter with actual construction on it is more expensieve than one without it. Hence the weight should be smaller than 1 to adjust for this. This formula clearly could be improved (e.g. it's  not taking into account that the square meters with construction are most likely duplicated in the total of squater meters for the terrain). There is an slider for this weight. "),
             h3("Upper and Lower bound"),
             p("The raw data, as usual, was not very good. There are sales which have an extremely low  Price by M2 (e.g. $0.001 per M2) and also others which have very high ones. These are likely to be input errors in the data. To deal with that, the lower and upper bound sliders are included. These sliders are in terms of (normalized) standard deviations from the mean Price by M2 " )
             
             ), 
    tabPanel("Plot", 
             flowLayout(
               sliderInput("weight", "Weigth", 0, 1, value=0.25),
               sliderInput("lowerBound", "lowerBound", -1, 0,value = -0.5),
               sliderInput("upperBound", "upperBound", 0, 1, value=0.5)
             ),
             plotOutput ("out")
             ), 
    tabPanel(
             "List of Regions",
             p("List of regions for Costa Rica. Provincias are the 1st level Region, while Cantones are 2nd level ones."),
             dataTableOutput("listOfRegions")
             )
  )
)
