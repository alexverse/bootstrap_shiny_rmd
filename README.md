# bootstrap_shiny_tech_talk
Bootstrap theming for shiny and Rmarkdown tech talk. 

Using bslib and thematic two examples are given for Rmarkdown and shiny.

- In app.R you can find an example of a shiny app that uses new bslib functionality.
- You can control the style of the shiny app throught a yaml file. Variables are seperated to low level and hight level ones.
- In server function you can comment in/out the `bs_themer()` function to get a live "themer".
- In Rmarkdown example high level SASS variables are tweaked.
- Both examples showcases some widgets that work well with bslib/thematic, and some that they partly work or need refactoring.
