library(shiny)
library(reticulate) 
library(dplyr)
library(ggplot2)
fooof <- import("fooof")
np <- import("numpy")
plt <- import("matplotlib.pyplot", as = "plt")

shinyServer(function(input, output) {

  data <- reactive({
    sub <- df[[input$condition]][[input$channels]][[input$subject]]
    elec <- which(colnames(sub$spectrum) == input$electrode)
    sub$spectrum <- sub$spectrum[ ,elec]
    return(sub)
  })
  
  
  fm <- eventReactive(input$run || input$tab == "Report", {

    fm <- fooof$FOOOF(peak_width_limits = as.list(c(input$peak_width_limits[1], input$peak_width_limits[2])), 
                      max_n_peaks = input$max_n_peaks, 
                      min_peak_height = input$min_peak_height, 
                      peak_threshold = as.integer(input$peak_threshold),
                      aperiodic_mode = input$aperiodic_mode, 
                      verbose = TRUE)
    
    fm$fit(freqs = np$ravel(data()$freqs), 
           power_spectrum = np$ravel(data()$spectrum), 
           freq_range = as.list(c(input$freq_range[1], input$freq_range[2])))
    
    return(fm)
    
  })
  
  
  output$ui_condition <- renderUI({
    if (input$tab == "About" && is.null(input$condition)) {
      selected <- "EC"
    } else {
      selected <- input$condition
    }
    selectInput(inputId = "condition",
                label = "Condition",
                choices = c("EC", "EO"),
                selected = selected)
  })
  
  
  output$ui_channels <- renderUI({
    if (input$tab == "About" && is.null(input$channels)) {
      selected <- "32"
    } else {
      selected <- input$channels
    }
    selectInput(inputId = "channels",
                label = "# of Channels",
                choices = c("32", "64"),
                selected = selected)
  })
  
  
  output$ui_electrodes <- renderUI({
    elecs <- colnames(df[[input$condition]][[input$channels]][[1]]$spectrum)
    selectInput(inputId = "electrode", 
                label = "Electrode", 
                choices = elecs,
                selected = input$electrode)
  })
  
  
  output$ui_subject_selected <- renderUI({
    
    IDs <- names(df[[input$condition]][[input$channels]])
    
    if (!is.null(input$alpha) && all(input$alpha == FALSE)) {
      IDs <- intersect(IDs, no_alpha[[input$condition]][[input$channels]][[input$electrode]])
    }
    
    selectInput(inputId = "subject", 
                label = "Subject ID", 
                choices = IDs, 
                selected = input$subject)
  })
  
  
  output$ui_freq_range <- renderUI({
    if (is.null(input$freq_range)) {
      selected <- c(1, 50)
    } else {
      selected <- input$freq_range
    }
    sliderInput("freq_range",
                "Frequency Range",
                min = 1,
                max = 50,
                step = 0.5,
                value = selected)
  })
  
  
  
  output$ui_peak_width_limits <- renderUI({
    if (is.null(input$peak_width_limits)) {
      selected <- c(2.5, 8)
    } else {
      selected <- input$peak_width_limits
    }
    sliderInput("peak_width_limits",
                "Peak Width Limits",
                min = 0,
                max = 20,
                step = 0.5,
                value = selected)
  })
  
  
  output$ui_max_n_peaks <- renderUI({
    if (is.null(input$max_n_peaks)) {
      selected <- 6
    } else {
      selected <- input$max_n_peaks
    }
    numericInput(inputId = "max_n_peaks", 
                 label = "Max Number of Peaks",
                 min = 1, 
                 max = 100,
                 step = 1,
                 value = selected)
  })
  
  
  output$ui_peak_threshold <- renderUI({
    if (is.null(input$peak_threshold)) {
      selected <- 2
    } else{
      selected <- input$peak_threshold
    }
    numericInput(inputId = "peak_threshold", 
                 label = "Peak Threshold",
                 min = 1, 
                 max = 10,
                 step = 0.5,
                 value = selected)
  })
  
  
  output$ui_min_peak_height <- renderUI({
    if (is.null(input$min_peak_height)) {
      selected <- 0.1
    } else {
      selected <- input$min_peak_height
    }
    numericInput(inputId = "min_peak_height", 
                 label = "Minimum Peak Height",
                 min = 0, 
                 max = 10,
                 step = .1,
                 value = selected)
  })
  
  
  output$ui_aperiodic_mode <- renderUI({
    if (input$tab == "About" && is.null(input$condition)) {
      selected <- "fixed"
    } else {
      selected <- input$aperiodic_mode
    }
    selectInput(inputId = "aperiodic_mode", 
                label = "Aperiodic Mode", 
                choices = c("fixed", "knee"), 
                selected = selected)
  })
  
  
  output$ui_plot_log_freq_dat <- renderUI({
    checkboxInput("plot_log_freq_dat", "Plot log(Frequency) on x-axis", value = input$plot_log_freq_dat)
  })
  
  
  output$ui_plot_log_power <- renderUI({
    checkboxInput("plot_log_power", "Plot log(Power) on y-axis", value = input$plot_log_power)
  })
  
  
  output$ui_show_electrodes <- renderUI({
    checkboxInput("all_elec", "Show all electrodes", value = input$all_elec)
  })
  
  
  output$ui_alpha <- renderUI({
    if (is.null(input$alpha)) {
      selected <- c("Yes" = TRUE, "No" = FALSE)
    } else {
      selected <- input$alpha
    }
    selectInput(inputId = "alpha",
                label = "Subject had alpha peak?",
                choices = c("Yes" = TRUE, "No" = FALSE),
                multiple = TRUE,
                selected = selected)
  })
  
  
  output$sidebarPanel <- renderUI({
    
    if (input$tab %in% c("About", "Report")) {
      
      sidebarPanel(width = 3,
        uiOutput("ui_condition"),
        uiOutput("ui_channels"),
        uiOutput("ui_electrodes"),
        uiOutput("ui_subject_selected"),
        uiOutput("ui_freq_range"),
        uiOutput("ui_peak_width_limits"),
        uiOutput("ui_max_n_peaks"),
        uiOutput("ui_peak_threshold"),
        uiOutput("ui_min_peak_height"),
        uiOutput("ui_aperiodic_mode"),
        actionButton(inputId = "run", label = "Run Model")) 
      
    } else if (input$tab == "Data") {
      
      sidebarPanel(width = 3,
        uiOutput("ui_condition"),
        uiOutput("ui_channels"),
        uiOutput("ui_electrodes"),
        uiOutput("ui_alpha"),
        uiOutput("ui_subject_selected"),
        uiOutput("ui_freq_range"),
        uiOutput("ui_show_electrodes"),
        uiOutput("ui_plot_log_freq_dat"),
        uiOutput("ui_plot_log_power"))
      
    } else {NULL}
  
  })
  
  
  output$subject_data <- DT::renderDataTable({
    as.data.frame(df[[input$condition]][[input$channels]][[input$subject]]$spectrum) %>% 
      mutate(Avg = rowMeans(.), Freq = df[[input$condition]][[input$channels]][[input$subject]]$freqs) %>% 
      round(2)
  })
  
  
  output$psd_all_plot <- renderPlot({
    psd_all_plot(df = df[[input$condition]][[input$channels]][[input$subject]],
                 freq_low = input$freq_range[1],
                 freq_high = input$freq_range[2],
                 log_freq = input$plot_log_freq_dat,
                 log_power = input$plot_log_power,
                 all_elec = input$all_elec,
                 elec = input$electrode)
  })
  
  
  output$psd_facet_plot <- renderPlot({
    psd_facet_plot(df = df[[input$condition]][[input$channels]][[input$subject]], 
                   freq_low = input$freq_range[1],
                   freq_high = input$freq_range[2],
                   log_freq = input$plot_log_freq_dat,
                   log_power = input$plot_log_power,
                   all_elec = input$all_elec,
                   elec = input$electrode)
  })
  
  
  output$report_plot <- renderImage({
    file <- tempfile(fileext = ".png")
    fm()$save_report(file)
    list(src = file, width = 800, height = 1000)
  }, deleteFile = TRUE)
    
    
})
