library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)

shinyUI(fluidPage(theme = shinytheme("sandstone"),
                  useShinyjs(),
                  tags$head(tags$style(HTML(
                  ' [for=freq_range]+span>.irs-bar {background: black;}
                    [for=peak_width_limits]+span>.irs-bar {background: black;}
                  '
                  ))
                  ),
                 
    titlePanel("Spectral Parameterization"),

    sidebarLayout(
        uiOutput("sidebarPanel"),
        mainPanel(
            tabsetPanel(id = "tab",
                tabPanel(title = "About",
                         h2("'specparam' Algorithm"),
                         HTML(overview_top),
                         br(),
                         br(),
                         fluidRow(HTML(mod_param_table), align = "center"),
                         br(),
                         h2("Suggested Reporting"),
                         HTML(example_report)),
                tabPanel(title = "Report",
                         plotOutput("report_plot")),
                tabPanel(title = "Data",
                         h4("FOOOF Settings for subjects without alpha peak"),
                         `no_alpha_fooof_settings`,
                         hr(),
                         br(),
                         plotOutput("psd_all_plot"),
                         plotOutput("psd_facet_plot"),
                         br(),
                         DT::dataTableOutput("subject_data")),
                tabPanel(title = "Website",
                         tags$iframe(src="https://fooof-tools.github.io/fooof/#", height=1200, width=1600)))
        )
    )
))
