# Chex Mix: Improved Pneumonia Detection

Improved pneumonia detection by combining a CNN with disease labels in a logistic regression classifier.

We intend to improve pneumonia detection from chest X-rays, basing our efforts on the pneumonia detection model CheXNet. Rajpurkar et al. (2017) trained a 121-layer convolutional neural network, called CheXNet, on the recently released NIH ChestX-ray14 dataset, which contains 112,120 frontal-view chest X-ray images individually labeled with up to 14 different thoracic diseases, including pneumonia. Of the cases labelled with pneumonia, less than one quarter have no other disease labels attached, so there appears to be a correlation with pneumonia and the other thoracic diseases. Existing state-of-the-art CNN models such as ChexNet do not consider the potential predictive power of these other diseases in detecting pneumonia. Therefore we predict that combining the final layer activations of the CNN with the other disease labels in a logistic regression classifier will give a significantly higher F1 score than the CNN alone in the classification of pneumonia. 

The full data set can be obtained at https://www.kaggle.com/nih-chest-xrays/data

The random subset can be obtained at https://www.kaggle.com/nih-chest-xrays/sample
