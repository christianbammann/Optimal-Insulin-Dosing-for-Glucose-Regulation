# Optimal Insulin Dosing for Glucose Regulation

This project explores how convex optimization techniques can be used to determine an optimal insulin dosing schedule for regulating blood glucose levels. A simplified linear model is used to represent how glucose levels change in response to insulin dosage and meal disturbances. The dosing problem is set up as a quadratic program (QP) that aims to keep glucose close to a target value while also minimizing how much insulin is used. Safety constraints are included to ensure insulin doses and glucose levels remain within realistic bounds. MATLAB’s optimization tools are used to solve the problem, and simulated meal inputs are used to test the model. The results show that convex optimization provides a practical way to design stable glucose control strategies in biomedical applications.

---

## Author
- **Christian Bammann** –  sole contributor of this project, including problem conceptualization, system modeling, optimization problem formulation, and MATLAB simulations.  

---

## Contents

| File                                                                                     | Description                                                 |
|------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `GlucoseRegulation.m`                                                                    | MATLAB Code                                                 |
| `FinalReport_GlucoseRegulation.pdf`                                                      | IEEE-style technical report                                 |
| `README.md`                                                                              | Project Summary                                             |

---

## Conclusion

This project demonstrated that convex optimization methods can be effectively utilized to create an optimized insulin dosing schedule that keeps glucose levels within safe limits while minimizing insulin usage. Using a simplified linear glucose–insulin model, the quadratic program was successful in regulating glucose levels from a high initial condition toward the optimal value of 110 mg/dL. The model showed robust performance, even with the added meal disturbances. The optimized dosing sequence remained within the predefined safe bounds and produced a stable glucose trajectory graph. These results indicate that convex optimization offers a practical method for exploring glucose control strategies. Future work for improvement would include implementing nonlinear models, multi-hormone control, or a closed-loop MPC implementation.
