#install.packages("httr2")
library(httr2)

# GET dry run examples ------------------------------------------------------------
local_url <- example_url()
local_url
req <- request(local_url)
req %>% 
  req_dry_run()

# GET with parameter and header -------------------------------------------------------
req <- request("http://165.22.92.178:8080") %>% 
  req_url_path("fib") %>%
  req_url_query(n = 7) %>%
  req_headers(authorization = "DM_DV_123#!")
req %>% req_dry_run() 
resp <- req %>% 
  req_perform()
resp %>%
  resp_body_string()


# GET with parameters and header API key with JSON  -----------------------------------------
# 'link' to the API can be found on Rapid API under 'code snippets' for R
# 'path' can be seen from in GET /v1/planets in the middle of the web page
# 'query'(name) is an optimal parameter which is here = 'Mars'. It specifies the request 
# 'headers' are authentication 
# Remember to always be subscribed to the API, otherwise it wont work! 

req <- request("https://planets-by-api-ninjas.p.rapidapi.com") %>%
  req_url_path("v1/planets") %>%
  req_url_query(name = "Mars") %>%
  req_headers('X-RapidAPI-Key' = 'fe7726b079msh62d449d9aaefebfp19dfa8jsn3356e4356fc9',
              'X-RapidAPI-Host' = 'planets-by-api-ninjas.p.rapidapi.com') 

# Here we send the request to the API and store the data in an obejct called 'resp'
resp <- req %>% 
  req_perform() 

# Extracting the 'repons' from the API as json
resp %>%
  resp_body_json()





# GET with string response NOT working as connection is timed out --------------------------------------------
# String
req <- request("http://165.22.92.178:8080") %>% 
  req_url_path("responses") %>%
  req_url_query(format = "string") %>%
  req_headers(authorization = "DM_DV_123#!")

response <- req %>% 
  req_perform()


response # Inspect content type
response %>%
  resp_body_string()





# POST dry run example ------------------------------------------------------------
# Body as an R list
req_body <- list(x = c(1, 2, 3), y = c("a", "b", "c"))
req_body

# Body transformed to JSON in the request
request(example_url()) %>%
  req_body_json(req_body) %>% 
  req_dry_run()







# POST with data ----------------------------------------------------------
# Simulate data
n <- 100
x1 <- rnorm(n = n)
x2 <- rnorm(n = n)
x3 <- rnorm(n = n)
y <- 2*x1 + 3*x2 + 2*x3 + rnorm(n = n)
df <- round(data.frame(y = y, x1 = x1, x2 = x2, x3 = x3))

library(webfakes)

# Construct a request including the data
req <- request("http://165.22.92.178:8080") %>% 
  req_url_path("lm") %>%
  req_body_json(as.list(df)) %>%
  req_headers(authorization = "DM_DV_123#!")

# Send the request to the API
resp <- req %>% 
  req_perform()

# View the result
resp %>%
  resp_body_json()




# POST with rapid API -----------------------------------------------------
# Inserting request link and headers from RapidAPI
# Inserting 'required' parameters in the body. 
req <- request("https://google-translate1.p.rapidapi.com/language/translate/v2") %>% 
  req_headers('X-RapidAPI-Key' = "fe7726b079msh62d449d9aaefebfp19dfa8jsn3356e4356fc9",
              'X-RapidAPI-Host' = 'google-translate1.p.rapidapi.com' ) %>%
  req_body_form(q = "Hello, world!",
                target = "da")

# Performing the request and storing the result
resp <- req %>% 
  req_perform()

result <- resp %>%
  resp_body_json()

result$data$translations




# OWN TEST POST - Trying 'Detect' with Google API-----------------------------------------------------
# Inserting request link and headers from RapidAPI
# Inserting 'required' parameters in the body. 
req = request("https://google-translate1.p.rapidapi.com/language/translate/v2/detect") %>%
  req_headers("X-RapidAPI-Key" = "fe7726b079msh62d449d9aaefebfp19dfa8jsn3356e4356fc9", 
              "X-RapidAPI-Host" = "google-translate1.p.rapidapi.com") %>%
  req_body_form(q = "Jeg er mega sej!")

resp = req %>%
  req_perform()

result = resp %>% 
  resp_body_json()

result$data$detections


