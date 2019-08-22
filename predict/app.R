library(shiny)
source("../create_model.R")

# Define UI
ui <- fluidPage(

    # Application title
    titlePanel("ACME Word-O-Matic", windowTitle = "Welcome to my capstone project"),

    sidebarLayout(
        sidebarPanel(
            h2("Welcome to my capstone project!"),
            h3("I've built three main gadgets:"),
            h3("Predict"),
            p("The main assignment for the capstone was to create a text prediction
              app. Start typing, and the app will return a prediction for your 
              next word (highlighted in yellow)."),
            h3("Inspect"),
            p("Get under the hood and see how the app makes its predictions! Enter
              some text and get a chart of the top prediciton possibilities along
              with their relative likelihood of being selected."),
            h3("Generate"),
            p("Have the model generate a random sentence. This is just for fun,
              as it will mostly create nonsense."),
            br(),
            tags$i("Navigate between gadgets using the tabs at the top")
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Predict",
                       br(),
                       
                       br(),
                       
                       h4("Start typing, and I will predict as you go:"),
                       
                       br(),
                       
                       textInput("phrase", label = NULL, placeholder = "Enter text here..."),
                       
                       br(),
                       
                       span(textOutput("phrase_start", inline = T), style = "font-size:large;"),
                       
                       span(textOutput("predicted_word", inline = T), style = "background-color: #FFFF00; font-size:large; ")
                       
                ),
                
                tabPanel("Inspect",
                         br(),
                         
                         br(),
                         
                         h4("Enter a word or phrase to see top matches:"),
                         
                         textInput("inspect", label = NULL, placeholder = "Enter text here..."),
                         
                         actionButton("inspect_go", label = "Go", icon = icon("check-circle")),
                         
                         textOutput("match_message"),
                         
                         plotOutput("matches")
                         
                         
                ),
                
                tabPanel("Generate",
                         br(),
                         
                         br(),
                         
                         h4("Press the button to generate a random sentence."),
                         
                         actionButton("sentence", "Give me some nonsense!"),
                         
                         br(),
                         br(),
                         
                         span(textOutput("sentence"), style = "font-size:large;")
                )
            )
        )
    )   
)

# Define server logic
server <- function(input, output) {
    
    # Get next word
    output$phrase_start <- renderText({input$phrase})
    output$predicted_word <- renderText({
        req(input$phrase)
        word <- get_next_word(input$phrase)
        if(word == 'i') word <- toupper(word)
        word
        })
    
    # Generate plot
    observeEvent(input$inspect_go, {
        req(input$inspect)
        
        #trigram plot
        if(nrow(get_possibilities(input$inspect, 3)) > 0){
            output$match_message <- NULL
            poss <- get_possibilities(input$inspect, 3)
            if(nrow(poss) > 10){
                poss <- poss[1:10,]
            }
            poss <- poss %>% mutate(n = n/sum(n))
            output$matches <- renderPlot({
                plot <- ggplot(data= poss, aes(x = reorder(word3, n), y = n)) +
                    geom_bar(stat = "identity", fill = "aquamarine3") +
                    coord_flip() +
                    ggtitle("Next word possibilities") +
                    xlab("") +
                    ylab("Probability of being picked") + 
                    labs(fill = "Trigram match") + 
                    theme(axis.text = element_text(size = 14),
                          title = element_text(size = 16))
                plot
            })
        }
        
        #bigram plot
        else if(nrow(get_possibilities(input$inspect, 2)) > 0){
            output$match_message <- NULL
            poss <- get_possibilities(input$inspect, 2)
            if(nrow(poss) > 10){
                poss <- poss[1:10,]
            }
            poss <- poss %>% mutate(n = n/sum(n))
            output$matches <- renderPlot({
                plot <- ggplot(data= poss, aes(x = reorder(word2, n), y = n)) +
                    geom_bar(stat = "identity", fill = "chocolate2") +
                    coord_flip() +
                    ggtitle("Next word possibilities") +
                    xlab("") +
                    ylab("Probability of being picked") +
                    theme(axis.text = element_text(size = 14),
                          title = element_text(size = 16))
                plot
            })
        }
        
        #display a message
        else{ 
            output$matches <- NULL
            output$match_message <- renderText({"No match found. In this case,
                the app guesses a word at random!"})
        }
    })
    
    
    # Generate sentence
    observeEvent(input$sentence,{ 
        output$sentence <- renderText({
            sentence <- generate_sentence()
            sentence})
        })

    
}
    


# Run the application 
shinyApp(ui = ui, server = server)
