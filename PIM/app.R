library(shiny)
library(survival)
library(survminer)

ui <- fluidPage(
  titlePanel("Survival Curves with Prognostic and Predictive Biomarkers"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Survival Model Equation"),
      withMathJax(helpText("The hazard rate \\( \\lambda \\) is modeled as:")),
      withMathJax(helpText("
        $$ \\lambda = \\frac{1}{\\exp(\\alpha + \\beta_{Px} \\cdot \\text{BM} + \\beta_{Pr} \\cdot \\text{Tx} \\cdot \\text{BM} + \\beta_{Tx} \\cdot \\text{Tx})} $$
      ")),
      sliderInput("alpha", "Baseline Log Hazard (\\(\\alpha\\)):", min = -1, max = 1, value = -0.1, step = 0.1),
      sliderInput("beta_prognostic", "Prognostic Coefficient (\\(\\beta_{px}\\)):", min = -1, max = 1, value = 0.2, step = 0.1),
      sliderInput("beta_predictive", "Predictive Coefficient (\\(\\beta_{pr}\\)):", min = -2, max = 2, value = 1.3, step = 0.1),
      sliderInput("beta_therapy", "Therapy Coefficient (\\(\\beta_{tx}\\)):", min = -2, max = 2, value = 1.3, step = 0.1),
      numericInput("n", "Number of Patients:", value = 500, min = 100, max = 10000),
      actionButton("simulate", "Simulate Data")
    ),
    
    mainPanel(
      plotOutput("survivalPlotWithTherapy"),
      plotOutput("survivalPlotWithoutTherapy")
    )
  )
)


server <- function(input, output) {
  simulate_data <- eventReactive(input$simulate, {
    N <- input$n
    biomarker <- sample(c(1, 5), size = N, replace = TRUE, prob = c(0.2, 0.8))
    TX <- sample(c(0, 1), size = N, replace = TRUE)
    BM <- biomarker == 1
    alpha <- input$alpha
    beta <- input$beta_prognostic * biomarker + input$beta_predictive * TX * BM + input$beta_therapy * TX
    mu <- exp(alpha + beta)
    lambda <- 1 / mu
    time_to_survival <- rexp(n = N, rate = lambda)
    event <- sample(c(0, 1), size = N, replace = TRUE)
    censoring <- runif(n = N, min = 0, max = time_to_survival)
    time_to_survival <- ifelse(event == 1, time_to_survival, censoring)
    data.frame(biomarker, time_to_survival, event, TX)
  })
  
  max_survival_time <- reactive({
    data <- simulate_data()
    max(data$time_to_survival)  # Get the maximum survival time
  })
  output$survivalPlotWithoutTherapy <- renderPlot({
    data <- simulate_data()
    data_no_therapy <- subset(data, TX == 0)  # Filter for no therapy
    fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker, data = data_no_therapy)
    ggsurvplot(
      fit, conf.int = TRUE, legend.labs = c("BM1", "BM2"),
      title = "Survival Curves: Without Therapy", xlab = "Time", ylab = "Survival Probability",
      xlim = c(0, max_survival_time())  # Use the maximum survival time for xlim
    )
  })  
  
  output$survivalPlotWithTherapy <- renderPlot({
    data <- simulate_data()
    fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)
    ggsurvplot(
      fit, conf.int = TRUE, legend.labs = c("BM1 no Tx", "BM1 Tx", "BM2 no Tx", "BM2 Tx"),
      title = "Survival Curves: With Therapy", xlab = "Time", ylab = "Survival Probability",
      xlim = c(0, max_survival_time())  # Use the maximum survival time for xlim
    )
  })
  
}


shinyApp(ui, server)
