# NOTE: Still in early alpha stage

The scipts and texts are extremely rudimentary, unfinished, lack proper documentation and so on. Proceed at your own discretion. 


# Decisional noise in GRT models

In this essay I will be considering the "classic" 2X2 categorization experiment, in which the participants are asked to categorize two-dimensional stimuli with two levels on both dimensons, hence the name. Results from these kinds of experiments are usually summarized in a 4X4 confusion matarix: the four response categories are on the columns and four stimulus categories on the rows. 

In this kind of model each stimulus is assumed to have its own latent bivariate normal distribution, and the probabilities for the participant assigning them to different categories are given by dividing the distributions in four quadrants by orthogonal decisional bounds. These boundaries model the "bias" of the observer, i.e. their tendency to e.g. categorize stimuli as having level 2 independent of their physical strength.

This basic model is demonstrated in the figure below:

![A simple demo of GRT, showing four bivariate distributions and orthogonal decisional boundaries](file://figures/grt_demo.png)

The circles depict bivariate normal distributions as they might look like when seen from above. Each of the circles is the assumed latent distribution for a combination of stimulus values on the two dimensions, for example the circle in the lower left corner corresponds to the stimulus with level 1 on both dimensions. 

The dashed lines correspond to the decisional boundaries. The proportions of each circle in each quadrant exceeding the boundaries give the categorization probabilities. Here, each stimulus is fairly likely to be categorized correctly. 

## Decisional noise

All variability during the detection process is "loaded" into the latent distributions. This includes external noise -  e.g. distractions from the real world - as well as internal noise, errors in cognitive processing and, indeed, any variability in the decisional boundaries. 

Usually it is assumed that at least *most* of the variability that the latent distributions model is due to internal/cognitive (other than decisional) factors and thus models the psychology of multidimensional perception. However, GRT experiments often consist of thousands of trials, with sessions divided among multiple days. I think it is likely that this induces a non-trivial amount of decisional variability. 

I will be exploring this issue here in a slightly more systematic way. First  I will conduct simulations with varying amounts of decisional noise to see how this affects the maximum likelihood estimates of the model parameters.