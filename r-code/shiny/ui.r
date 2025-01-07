
ui = dashboardPage(
  header = dashboardHeader(title="Shiny demo"),
  sidebar = dashboardSidebar(
    br(),
    br(),
    sidebarMenu(id="sidebarmenu",
      menuItem("Introduction", tabName="introduction"),
      menuItem("Summary table", tabName="table"),
      menuItem("Stock-recruit relationship (SRR)", tabName="srr_plots")
    ),

    # Only show these on the plotting tabs - not Introduction and Summary table tabs
    conditionalPanel(condition="input.sidebarmenu == 'srr_plots'",
      # srr-show-est
      switchInput(
      inputId = "srr_show_est",  
      label = "Show estimated recruitment",
      value=TRUE,
      onLabel = "TRUE",
      offLabel = "FALSE",
      onStatus = "success", 
      offStatus = "danger"),
      # srr-est-type
      awesomeRadio(
      inputId = "srr_est_type",  
      label = "Plot estimated recruitment as:",
      choices=c("Path","Points","Both"),
      selected = "Path")
    ),
    br(),
    br(),
    tags$footer(
      div(style="text-align:center",
        tags$p("version 0.0.1"),
        tags$p(paste("Copyright", format(Sys.time(),"%Y"), "NOAA Fisheries, PIFSC Stock Assessment Group"))
      )
    )
  ), # End of sidebar

  body = dashboardBody(
    tags$head(tags$style(HTML('.wrapper {height: auto !important; position:relative; overflow-x:hidden; overflow-y:hidden}') )),
    tags$head(tags$style(css)),
    # Start of main tab stuff
    tabItems(
      # **** Introduction ****
      tabItem(tabName="introduction", h2("Introduction"),
        fluidRow(column(12, includeMarkdown(paste0("./r-code/shiny/introduction_index.md"))))
      ), # End of introduction tab

      # **** Summary table ****
      tabItem(tabName="table", h2("Summary table"),
        fluidRow(box(title="Model metrics", collapsed=start_collapsed, solidHeader=TRUE, collapsible=TRUE, status="primary", width=12,
         DT::dataTableOutput("summarytable")))
      ), # End of table tab

      # **** Stock recruitment plots ****
      tabItem(tabName="srr_plots", h2("Stock-recruitment plots"),
        fluidRow(
          box(title="Stock-recruitment relationship (SRR)", solidHeader=TRUE, collapsible=TRUE, collapsed=start_collapsed, status="primary", width=12,
            p("Select at least one model."),
            plotOutput("srr_plots", height="auto"))
        )
      ) # End of srr_plots tab
    ) # End of tabItems
  ) # End of dashboardBody
)
