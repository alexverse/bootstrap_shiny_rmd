
options(shiny.autoreload = TRUE, dev.mode = TRUE)

library(shiny)
library(thematic)
library(bslib)
library(plotly)
library(ggplot2)
library(shinyWidgets)
library(echarts4r)

#for cohesive look of your plots
thematic_shiny(font = "auto")

#make bs_lib object from yaml file
my_theme_args <- config::get(file = "bs.yml")$my_theme
my_theme <- do.call(bs_theme,
                    my_theme_args$hight_lvl) |>
  bs_add_variables(!!!my_theme_args$low_lvl)

# my_theme <- bs_theme(version = 5)
nav_items <- function() {
  list(
    nav(
      "Home",
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            "bins",
            "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          ),
          actionButton(
            "warn-button",
            "Warning outline button",
            class = "btn-outline-warning" #class with more specificity applies
          )
        ),
        mainPanel(
          plotOutput("faithful_ggplot")
        )
      )
    ),
    nav(
      "GGPlotly",
      plotlyOutput("ggplotly")
    ),
    nav(
      "DT",
      DT::dataTableOutput("datatable")
    ),
    nav(
      "echarts4r",
      fluidRow(
        column(12, actionButton("update", "Update"))
      ),
      fluidRow(
        column(12, echarts4rOutput("plot4r"))
      )
    )
  )
}

# navbar constractor using bs_theme object
ui <- page_navbar(
    title = titlePanel("", "Hello, bslib!"),
    theme = my_theme,
    inverse = FALSE,
    !!!nav_items()
)

server <- function(input, output, session) {
  
    bslib::bs_themer()
  
    output$faithful_ggplot <- renderPlot({
      x <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      hist(x, breaks = bins)
    })
    
    output$ggplotly <- renderPlotly({
      g <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
        geom_col() 
      ggplotly(g)
    })
    
    output$datatable = DT::renderDataTable({
      DT::datatable(mtcars)
    })
    
    data4r <- eventReactive(input$update, {
      Sys.sleep(1) # sleep one second to show loading
      data.frame(
        x = 1:10,
        y = rnorm(10)
      )
    })
    
    output$plot4r <- renderEcharts4r({
      data4r() |> 
        e_charts(x) |> 
        e_bar(y) |> 
        e_show_loading()
    })
    
    points <- eventReactive(input$recalc, {
      cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
}

shinyApp(ui = ui, server = server)
