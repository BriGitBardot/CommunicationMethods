# define javascript function for responsive sizing of plots
jscode <-
  '$(document).on("shiny:connected", function(e) {
  var jsWidth = $(window).width();
  Shiny.onInputChange("GetScreenWidth",jsWidth);
});'

# loading the necessary packages into the session
library(shiny)
library(rCharts)
library(plyr)
library(RColorBrewer)
library(ggplot2)
library(shinythemes)

# making sure that the dataset will be read properly from the data folder
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)

methods = read.csv("methods_eng_agg.csv", header = TRUE, sep=";", na.strings = c("NA", "", " "))

# resetting the working directory
setwd(wd.init)

shinyApp(
  ui = fluidPage(tags$head(tags$style(HTML("
                                      @import url('//fonts.googleapis.com/css?family=Pacifico|Righteous|Rock Salt|Permanent Marker|Waiting for the Sunrise|Indie Flower|Architects Daughter|Handlee:400,700');
                                           .control-label {
                                           color: #37C4A8;
                                           }    
                                           .single {
                                           width: 120px;
                                           }
                                           @media (min-width: 410px){
                                           h2 div {
                                           font-size: 62px;
                                           
                                           }}                                        
                                           "))
  ),
  tags$script(jscode),
  # add CSS theme 
  theme = shinytheme("flatly"),
  
  
  
  # title
  titlePanel(title=div("Communication Research Methods", style = "padding-left: 1.5%; padding-top: 25px;  padding-bottom: 15px; font-family:'Handlee'; color: #1ABC9C"), windowTitle = "Communication Research Methods"),
  # create sidebar 
  sidebarPanel(tags$head(tags$style(HTML("
                                         @media (max-width: 1255px) AND (min-width: 470px){
                                         .col-sm-4 {
                                         float:left;
                                         width: 100%;
                                         
                                         }
                                         .col-sm-8 {
                                         float:left;
                                         width: 100%;
                                         
                                         }
                                         img{
                                         max-width:350px;
                                         }}     
                                         @media (max-width: 1255px) AND (min-width: 970px){
                                         img{
                                         margin-left:55%;
                                         padding-left: 5%
                                         }}
                                         "))
  ),
  #textOutput("results"),
  helpText('This application features interactive graphics and tables that display the uses of the three basic methods â interview/survey, observation, and content analysis - in the field of communication research during the years 2000 to 2015.'),
  helpText('You can modify the layout of these plots by deselecting one or more of the lables from the legends above the plots. The plots also feature tooltips that tell the exact value for a specific data point when you hower over it.'),
  helpText(paste('The results rely on an extensive content analysis of 32 scientific journals conducted by the  '), a("Department of Communication", href="http://www.uni-muenster.de/KOWI", 
                                                                                                                      target= "blank"),'  at the University of MÃ¼nster. In sum, 6953 empirical articles were coded.'),
  helpText("To meet the scientific requirement of transparency, the entire dataset can be downloaded in the âData Tableâ tab."),
  helpText(paste('For more details on the project please confer '), a("this publication", href="http://www.halem-verlag.de/2014/beobachtungsverfahren-in-der-kommunikationswissenschaft/", target="blank"), "."),                                 
  p(span(strong("Note: This application is optimized for desktop browsers. If you access it from a mobile device, 
                we strongly recommend changing to landscape mode.", class="help-block" , style="color:#000000"))), 
  a(href="http://www.uni-muenster.de/", target= "blank", img(src = "wwu.png", width= "40%", style = "margin-left: 30%"))
  
  
  ),
  # create main panel
  mainPanel(tags$head(tags$style(HTML("
                                      @media (max-width: 960px)AND (min-width: 470px){
                                      svg{
                                      width: 100%;
                                      viewBox: 0 0 w h;
                                      }
                                      }   
                                      @media (max-width: 860px)AND (min-width: 470px){
                                      svg{
                                      width: 100%;
                                      viewBox: 0 0 w h;
                                      }
                                      img{
                                      min-width:200px;
                                      }}                                      
                                      "))
  ),
  tabsetPanel(type = "tabs",
              # tab for display of methods across time 
              tabPanel("Across Time",
                       # draw plot 
                       br(),
                       helpText(' '),
                       helpText('This tab depicts the distribution of the three canonic methods during the past years.'),
                       br(),
                       helpText(h3("Data Gathering Methods used in Communications Science", align="center", style = "color:#37C4A8"),
                                h4("[from 2000 to 2015]", align="center", style = "color:#838484")), 
                       div(showOutput("myChart1", "nvd3"))                                                 
              ),
              # tab for display of methods across diffenrent media, fields of study or subjects 
              tabPanel("By Medium, Field, and Subject",
                       br(),
                       helpText(' '),
                       helpText('This tab provides detail on the different areas in which the methods occur. 
                                Depenting on your selection, the data will either render for research on different media, research subjects or fields of study.'),
                       selectInput('selection', 'How shall the methods be grouped?', c("by medium" = "Medium","by field" = "Field", "by subject" = "Subject"),
                                   selected=names("Medium")),
                       
                       helpText(h3("Research on Different Media, Subjects, and Fields of Study", align="center", style = "color:#37C4A8"),
                                h4("by Data Gathering Method", align="center", style = "color:#838484")),
                       showOutput("myChart2", "nvd3")
                       
                       ),
              # data table tab
              tabPanel("Data Table",
                       br(),
                       helpText('This tab offers the opportunity to navigate through all
                                6953 cases of the underlying dataset.'),
                       helpText('Click on the arrow keys to sort the columns or use the search function to access specific cases.'),
                       helpText(paste('Yet, this dataset only contains an aggregated version of the original data. If you want to inspect 
                                      and/or work with the original data, you can download the entire dataset '), a("in csv format",
                                                                                                                    href="methods_eng_agg.csv", target="_blank"), (' (438 kBs, english labels) or '), a("SPSS format", href="methoden.sav", target="_blank"), (' (1667 kBs, german lablels).')
                       ),
                       br(),
                       dataTableOutput("mytable1")
                       ),
              # about tab
              tabPanel("About",
                       helpText(h3('General')),
                       helpText(paste('This app was developed in RStuido [release 0.99.467, incorporating R version 3.2.1. (64-bit)] and relies on the packages '), 
                                a("data.table", href="https://cran.r-project.org/web/packages/data.table/index.html", 
                                  target= "blank"), ', ',
                                a("RColorBrewer", href="https://cran.r-project.org/web/packages/RColorBrewer/index.html", 
                                  target= "blank"),', ',
                                a("ggplot2", href="https://cran.r-project.org/web/packages/ggplot2/index.html", 
                                  target= "blank"),', ',
                                a("shiny", href="https://cran.r-project.org/web/packages/shiny/index.html", 
                                  target= "blank"),', ',
                                a("shinythemes", href="https://cran.r-project.org/web/packages/shinythemes/index.html", 
                                  target= "blank"), ', ',
                                a("rCharts", href="https://ramnathv.github.io/rCharts/", 
                                  target= "blank"), ', and ',
                                a("plyr", href="https://cran.r-project.org/web/packages/plyr/index.html", 
                                  target= "blank"), '.'),
                       helpText(h3('Citing the App')),
                       helpText('If you want to cite the content of this app, please refer to it as:'), 
                       p(span("Hamachers, A., & Gehrau, V. (2016). ", em(" Communication Research Methods (Version 1.2)"), " [online application]. 
                              Available from http://shinika.shinyapps.io/CommunicationMethods.", class="help-block")),
                       helpText(h3('Source Code & Contact')),
                       helpText(paste('For full reproducibility the source code for the entire app can be retrieved from '), 
                                a("this Github repository", href="https://github.com/BriGitBardot/CommunicationMethods", 
                                  target= "blank"), '.  Feel free to fork and/or contribute!'),
                       helpText(paste('If you have any further questions or advice regarding this project, feel also free to '), 
                                a("mail us", href="mailto:annika.hamachers@googlemail.com", 
                                  target= "blank"), '!'),
                       hr()
                       )
                       )
  )
  ),
  
  server = function(input, output, session) {
    
    scree <- function() {
      input$GetScreenWidth
    }
    obs <- observe({
      cat(input$GetScreenWidth)
    })
    
    # test <- function() {
     # ({scree() })
     #}
     
     output$results<- reactive({input$GetScreenWidth})

       
    # Creating the time series plot as output for the first tab panel
    output$myChart1 <- renderChart({
      
      # aggegating data for the time series by summarizing by year 
      # for each method and concatenating the four data frames
      A <- ddply(methods, .(Year), summarize,
                 Freq=sum(Observation=="yes", na.rm= T))
      A["Method"] <- "Observation"
      B <- ddply(methods, .(Year), summarize,
                 Freq=sum(Survey=="yes", na.rm= T))
      B["Method"] <- "Interview"
      C <- ddply(methods, .(Year), summarize,
                 Freq=sum(Content.Analysis=="yes", na.rm= T))
      C["Method"] <- "Content Analysis"
      D <- ddply(methods, .(Year), summarize,
                 Freq=sum(Other=="yes", na.rm= T))
      D["Method"] <- "Other"
      methods_line <- rbind(A, B, C, D)
      
      
      # Plotting
      n1 <- nPlot(
        Freq ~ Year, 
        data = methods_line, 
        group = "Method",
        type = "lineChart")
      
      #define colors for the plot
      colors <- brewer.pal(6, "Set2")
      colors <- colors[3:6]
      
      # Add axis labels, colors, and format the tooltip
      n1$yAxis(axisLabel = "Frequency", width = 62)
      n1$xAxis(axisLabel = "Year")
      n1$chart(color = colors)
      
      if (input$GetScreenWidth < 900) {
        n1$params$width <- 600
        n1$params$height <- 300
      } else {
        n1$params$width <- 800
        n1$params$height <- 400
      }
      n1$chart(tooltipContent = "#! function(key, x, y){
               return '<h3>' + key + '</h3>' + 
               '<p>' + y + ' in ' + x + '</p>'
    } !#")           
      n1$set(dom = "myChart1")
      print(n1)
  })
    
    # Creating the bar plot as output for the second tab panel
    output$myChart2 <- renderChart({
      
      # aggegating data for the first optional bar plot by summarizing by medium 
      # for each method and concatenating the four data frames 
      # and eliminating missing values
      E <- ddply(methods, input$selection, summarize,
                 Freq=sum(Observation=="yes", na.rm= T))
      E["Method"] <- "Observation"
      G <- ddply(methods, input$selection, summarize,
                 Freq=sum(Survey=="yes", na.rm= T))
      G["Method"] <- "Interview"
      H <- ddply(methods, input$selection, summarize,
                 Freq=sum(Content.Analysis=="yes", na.rm= T))
      H["Method"] <- "Content Analysis"
      I <- ddply(methods, input$selection, summarize,
                 Freq=sum(Other=="yes", na.rm= T))
      I["Method"] <- "Other"
      methods_bar <- rbind(E, G, H, I)
      methods_bar = methods_bar[complete.cases(methods_bar),]
      
      
      # rendering one of three different bar plots in dependence on wheater the user selected the option
      # 'by Medium', 'by Subject' or 'by field'
      n2 <- nPlot(Freq ~ Method, group = input$selection, data = methods_bar, type = 'multiBarChart');
      
      #define colors
      colors2 <- brewer.pal(8, "Set2")
      
      # Add axis labels and colors
      n2$yAxis(axisLabel = "Frequency", width = 62, tickFormat = "#!d3.format('.0f')!#")
      n2$xAxis(axisLabel = "Method")
      n2$chart(color = colors2)
      if (input$GetScreenWidth < 900) {
        n2$params$width <- 600
        n2$params$height <- 300
      } else {
        n2$params$width <- 800
        n2$params$height <- 400
      }
      n2$set(dom = "myChart2")
      return(n2)
    })
    
    # Creating the data table as output for the third tab panel
    output$mytable1 = renderDataTable({
      methods
    }, options = list(lengthMenu = c(10, 25, 50, 100), scrollX=TRUE, pageLength = 5, orderClasses = TRUE))
    
    })
