library(readxl)
sleep <- read_excel("Downloads/Bedtime2.xlsx")

sleep$chronotype <- factor(sleep$chronotype)
sleep$occupation_type <- factor(sleep$occupation_type)
sleep$shift_worker <- factor(ifelse(sleep$occupation_type == "Shift", "Shift", "Non-shift"))

#t-test on total sleep hours and shift worker category
t.test(total_sleep_hours ~ shift_worker, data = sleep)

      Welch Two Sample t-test

data:  total_sleep_hours by shift_worker
t = 32.068, df = 1312.8, p-value < 2.2e-16
alternative hypothesis: true difference in means between group Non-shift and group Shift is not equal to 0
95 percent confidence interval:
 1.330537 1.503938
sample estimates:
mean in group Non-shift     mean in group Shift 
               6.432443                5.015206 

#anova test on total sleep hours and chronotype
anova_model <- aov(total_sleep_hours ~ chronotype, data = sleep)
summary(anova_model)

              Df Sum Sq Mean Sq F value Pr(>F)    
chronotype     2   6670    3335    2551 <2e-16 ***
Residuals   8497  11107       1                   
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

TukeyHSD(anova_model)

Tukey multiple comparisons of means
  95% family-wise confidence level

Fit: aov(formula = total_sleep_hours ~ chronotype, data = sleep)

$chronotype
                                diff        lwr       upr p adj
Morning Lark-Intermediate  0.9432053  0.8713107  1.015100     0
Night Owl-Intermediate    -1.4263592 -1.4954746 -1.357244     0
Night Owl-Morning Lark    -2.3695645 -2.4485795 -2.290550     0

#chi-square test on chronotype and occupation type
chisq.test(table(sleep$chronotype, sleep$occupation_type))

      Pearson's Chi-squared test

data:  table(sleep$chronotype, sleep$occupation_type)
X-squared = 8.5893, df = 8, p-value = 0.3781

#correlation test on bedtime phone and sleep latency minutes
cor.test(sleep$bedtime_phone_minutes, sleep$sleep_latency_min)

	    Pearson's product-moment correlation

data:  sleep$bedtime_phone_minutes and sleep$sleep_latency_min
t = 153.65, df = 8498, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.8517811 0.8630384
sample estimates:
      cor 
0.8575124 

#linear regression model
reg <- lm(next_day_fatigue_score ~ bedtime_phone_minutes + caffeine_post_5pm_mg + physical_activity_min + age + chronotype + occupation_type, data = sleep)
summary(reg)

Call:
lm(formula = next_day_fatigue_score ~ bedtime_phone_minutes + 
   caffeine_post_5pm_mg + physical_activity_min + age + chronotype + 
   occupation_type, data = sleep)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.7063 -0.8692 -0.0305  0.8140  4.8386 

Coefficients:
                           Estimate Std. Error t value Pr(>|t|)
(Intercept)               0.1110098  0.0607802   1.826 0.067823
bedtime_phone_minutes     0.0522098  0.0003774 138.351  < 2e-16
caffeine_post_5pm_mg      0.0096689  0.0002683  36.035  < 2e-16
physical_activity_min    -0.0027685  0.0006696  -4.134 3.59e-05
age                      -0.0043583  0.0012033  -3.622 0.000294
chronotypeMorning Lark   -1.0071431  0.0344721 -29.216  < 2e-16
chronotypeNight Owl       1.9517318  0.0331401  58.893  < 2e-16
occupation_typeFreelance  0.0730003  0.0491477   1.485 0.137495
occupation_typeRemote    -0.0443659  0.0367685  -1.207 0.227609
occupation_typeShift      1.9350700  0.0473010  40.910  < 2e-16
occupation_typeStudent   -0.0688274  0.0399850  -1.721 0.085228

(Intercept)              .  
bedtime_phone_minutes    ***
caffeine_post_5pm_mg     ***
physical_activity_min    ***
age                      ***
chronotypeMorning Lark   ***
chronotypeNight Owl      ***
occupation_typeFreelance    
occupation_typeRemote       
occupation_typeShift     ***
occupation_typeStudent   .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.284 on 8489 degrees of freedom
Multiple R-squared:  0.7715,	Adjusted R-squared:  0.7712 
F-statistic:  2866 on 10 and 8489 DF,  p-value: < 2.2e-16

#poisson regression model
pois <- glm(next_day_fatigue_score ~ bedtime_phone_minutes + caffeine_post_5pm_mg + physical_activity_min + age + chronotype + occupation_type, data = sleep)
summary(pois)

Call:
glm(formula = next_day_fatigue_score ~ bedtime_phone_minutes + 
    caffeine_post_5pm_mg + physical_activity_min + age + chronotype + 
    occupation_type, data = sleep)

Coefficients:
                           Estimate Std. Error t value Pr(>|t|)
(Intercept)               0.1110098  0.0607802   1.826 0.067823
bedtime_phone_minutes     0.0522098  0.0003774 138.351  < 2e-16
caffeine_post_5pm_mg      0.0096689  0.0002683  36.035  < 2e-16
physical_activity_min    -0.0027685  0.0006696  -4.134 3.59e-05
age                      -0.0043583  0.0012033  -3.622 0.000294
chronotypeMorning Lark   -1.0071431  0.0344721 -29.216  < 2e-16
chronotypeNight Owl       1.9517318  0.0331401  58.893  < 2e-16
occupation_typeFreelance  0.0730003  0.0491477   1.485 0.137495
occupation_typeRemote    -0.0443659  0.0367685  -1.207 0.227609
occupation_typeShift      1.9350700  0.0473010  40.910  < 2e-16
occupation_typeStudent   -0.0688274  0.0399850  -1.721 0.085228

(Intercept)              .  
bedtime_phone_minutes    ***
caffeine_post_5pm_mg     ***
physical_activity_min    ***
age                      ***
chronotypeMorning Lark   ***
chronotypeNight Owl      ***
occupation_typeFreelance    
occupation_typeRemote       
occupation_typeShift     ***
occupation_typeStudent   .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 1.649629)

    Null deviance: 61278  on 8499  degrees of freedom
Residual deviance: 14004  on 8489  degrees of freedom
AIC: 28390

Number of Fisher Scoring iterations: 2
