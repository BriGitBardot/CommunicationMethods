# loading the necessary packages into the session
library(shiny)
library(ggplot2)
library(shinythemes)
library(rCharts)


# setting up the an user interface with navigation panels, title and shiny theme
shinyUI(navbarPage('Methods Used in Communication Science', theme = shinytheme("cerulean"), 
            
            # creating the first tab panel with a sidebar containing information on the project and
            # a main panel rendering an rCharts time series depicting the relation 
            # of methods used across time
            tabPanel('Across Time',
            sidebarLayout(
                sidebarPanel(
                  img(src = "wwu_logo.png", width= "55%"),
                  helpText(' '),
                  helpText(paste('This application was set up to display the uses of the three major methods - 
                           survey, observation, and content analysis -in the field of communication research as has been analysed
                           in a research project of the '), a("Department of Communication", href="http://www.uni-muenster.de/KOWI", 
                           target= "blank"),' at the University of Münster. For more documentation please also confer the readme.md 
                           file associated with this app.'),
                  helpText('This first tab displays the distribution to the three methods 
                            during the years 2000 to 2010.'),
                  helpText('You can modify the layout of this time series plot by deselecting one or more 
                           methods by simply clicking on the associated lable above the plot. This plot also features a tooltip 
                           that tells the exact value for a specific method in a specific year when the cursor of the mouse is pointed 
                           directly at the line.')
                    ),
                mainPanel(
                    showOutput("myChart1", "nvd3")
                )
            )
        ),
                   
        # creating the second tab panel with a sidebar containing instructions on how to 
        # manipulate the appearance of the barplot shown in the main panel. The plot can be forced to
        # render differently, either depicting the distribution of methods by medium or by subject. 
        tabPanel('By Medium & Subject',
            sidebarLayout(
                sidebarPanel(
                  img(src = "wwu_logo.png", width= "55%"),
                  helpText(' '),
                  helpText('This tab provides the user of this app with a bit more detail on the different areas in which the methods occur. 
                           Depenting on your selection, the data will either render for the distribution of different media or research 
                           subjects each method focuses on.'),
                  selectInput('selection', 'How shall the methods be grouped?', c("by medium", "by subject"),
                              selected=names("by Medium")),
                  helpText('Again, the layout of this barplot can be modified by deselecting one or more 
                           options by simply clicking on the associated lable above the plot. This plot also features a tooltip 
                           that tells the exact value for a specific subject/medium for each method when the cursor hovers over the bar. 
                           You can also decide wheather the bars shall be displayed grouped or stacked.')
                ),
                mainPanel(
                    showOutput("myChart2", "nvd3")
                )
             )
        ), 
  
        # creating the last tab panel with a sidebar containing a little more information on the 
        # underlying dataset, instructions on how navigate the data table shown in the main panel 
        # and an additional download link to the entire dataset in csv format
        tabPanel('Frequency Tables',
            sidebarLayout(
                sidebarPanel(
                  img(src = "wwu_logo.png", width= "55%"),
                  helpText(' '),
                  helpText('This tab offers the opportunity to navigate through all
                            4434 cases of the underlying dataset.'),
                  helpText('Click on the arrow keys to sort the columns or use the search function to access specific cases.'),
                  helpText(paste('Yet, this dataset only contains an aggregated version of the original data. If you want to inspect 
                            and/or work with the original data, you can download the entire '), a("dataset in csv format",
                            href="~/data/methods_eng.csv"), ' (438 kBs).')
                ),
                mainPanel(dataTableOutput("mytable1")
                )
           )
  )
)
)