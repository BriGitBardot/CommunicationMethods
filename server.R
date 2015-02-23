# loading the necessary packages into the session
library(shiny)
library(rCharts)
library(plyr)

# making sure that the dataset will be read properly from the data folder
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)

methods = read.csv("methods_eng_agg.csv", header = TRUE, sep=";", na.strings = c("NA", "", " "))

# resetting the working directory
setwd(wd.init)

# setting up the shiny server function
shinyServer(function(input, output) {
  
    # Creating the time series plot as output for the first tab panel
    output$myChart1 <- renderChart({
      
    # aggegating data for the time series by summarizing by year 
    # for each method and concatenating the four data frames
    A <- ddply(methods, .(Year), summarize,
               Freq=sum(Observation=="yes", na.rm= T))
    A["Method"] <- "Observation"
    B <- ddply(methods, .(Year), summarize,
               Freq=sum(Survey=="yes", na.rm= T))
    B["Method"] <- "Survey"
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
    
    # Add axis labels and format the tooltip
    n1$yAxis(axisLabel = "Frequency", width = 62)
    n1$xAxis(axisLabel = "Year")
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
    E <- ddply(methods, .(Medium), summarize,
               Freq=sum(Observation=="yes", na.rm= T))
    E["Method"] <- "Observation"
    G <- ddply(methods, .(Medium), summarize,
               Freq=sum(Survey=="yes", na.rm= T))
    G["Method"] <- "Survey"
    H <- ddply(methods, .(Medium), summarize,
               Freq=sum(Content.Analysis=="yes", na.rm= T))
    H["Method"] <- "Content Analysis"
    I <- ddply(methods, .(Medium), summarize,
               Freq=sum(Other=="yes", na.rm= T))
    I["Method"] <- "Other"
    methods_bar <- rbind(E, G, H, I)
    methods_bar = methods_bar[complete.cases(methods_bar),]
    
    
    # aggegating data for the second optional bar plot by summarizing by subject 
    # for each method and concatenating the four data frames 
    # and eliminating missing values
    J <- ddply(methods, .(Subject), summarize,
               Freq=sum(Observation=="yes", na.rm= T))
    J["Method"] <- "Observation"
    K <- ddply(methods, .(Subject), summarize,
               Freq=sum(Survey=="yes", na.rm= T))
    K["Method"] <- "Survey"
    L <- ddply(methods, .(Subject), summarize,
               Freq=sum(Content.Analysis=="yes", na.rm= T))
    L["Method"] <- "Content Analysis"
    M <- ddply(methods, .(Subject), summarize,
               Freq=sum(Other=="yes", na.rm= T))
    M["Method"] <- "Other"
    methods_bar2 <- rbind(J, K, L, M)
    methods_bar2 = methods_bar2[complete.cases(methods_bar2),] 
    
    # rendering one of two different bar plots in dependence on wheater the user selected the option
    # 'by Medium' or 'by Subject'
    if (input$selection == "by subject") {
      n2 <- nPlot(Freq ~ Method, group = "Subject", data = methods_bar2, type = 'multiBarChart');
    }
    if (input$selection == "by medium"){
      n2 <- nPlot(Freq ~ Method, group = "Medium", data = methods_bar, type = 'multiBarChart');
    }
    # Notice: I would have wished to omit these if statements and do the input selection directly in the 
    # ddply function like this:
    #J <- ddply(methods, .(input$selection), summarize,
    #           Freq=sum(Observation=="yes", na.rm= T))
    # Unfortunaltely this did not work. If you have any ideas why, I'd be glad if you let me know!
    
    
    # Add axis labels
    n2$yAxis(axisLabel = "Frequency", width = 62)
    n2$xAxis(axisLabel = "Method")
    n2$set(dom = "myChart2")
    return(n2)
  })
  
  # Creating the data table as output for the third tab panel
  output$mytable1 = renderDataTable({
    methods
  }, options = list(lengthMenu = c(10, 25, 50, 100), pageLength = 5, orderClasses = TRUE))
  
})