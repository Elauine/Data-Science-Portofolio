# Predictive Modeling of Employee Attrition

## Directed by
**Elauïne BERNARD**  
*Statistician, Econometrician / Data Scientist*

## Objective

This project aims to build a predictive model that identifies the likelihood of employee attrition based on several features, using Python's machine learning libraries. The model is designed to help HR departments anticipate and mitigate employee turnover, enabling better employee retention strategies.

## Project Plan

1. **Data Import and Processing**  
   - Collected and loaded the data for further analysis.
   
2. **Exploratory Data Analysis (EDA)**  
   - Conducted initial data exploration to understand distributions, relationships, and key patterns.

3. **Feature Engineering**  
   - Processed and transformed the data into meaningful features for model training (e.g., one-hot encoding for categorical data, scaling, etc.).

4. **Model Training**  
   - Trained several machine learning models, including Logistic Regression, KNN, and Random Forest.

5. **Model Testing and Evaluation**  
   - Evaluated model performance on a test set and compared accuracy metrics to identify the best-performing model.

## Results

- **Logistic Regression**: Accuracy on test set: `89.80%`
- **KNN**: Accuracy on test set: `86.39%`
- **Random Forest**: Accuracy on test set: `90.14%`

Based on these results, the **Random Forest** model performed the best for predicting employee attrition. Therefore, it was chosen as the final model for this task.

## Technologies Used

- **Python** (Version 3.x)
- **Libraries**:
  - `pandas`, `numpy` for data manipulation
  - `scikit-learn` for model training, hyperparameter tuning, and evaluation
  - `seaborn`, `matplotlib` for data visualization

## How to Use

1. **Clone the repository** to your local machine:
   ```bash
   git clone https://github.com/your-username/your-repo.git
