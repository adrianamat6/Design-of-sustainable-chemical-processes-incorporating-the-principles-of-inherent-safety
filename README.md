# Design-of-sustainable-chemical-processes-incorporating-the-principles-of-inherent-safety

The most important files  are briefly presented below: 

·  Design of sustainable chemical processes incorporating the principles of inherent safety = it is a pdf in which the project is
explained 

·  2.Design of sustainable chemical processes incorporating the principles of inherent safety = it is a powerpoint  in which the main 
ideas are raised. 

· create_interpoling_surface, create_sampling, createFit, Datos_30P_2D, datos_GAMS, evaluate_interpolating_surface, GDX_fill_zeros,
interpolating_PFR_with_Hysys_v2 = they are Matlab files with which Aspen Hysys and Matlab exchange information in order to create a 
subrogate model of the reactor (see connections). The subrogate model presents as independent variables the reactor length and the input 
ethylbenzene mole flowrate. Matlab files create the best 30 points combinations of these two variables and send the information to Aspen 
Hysys to carry out the reactor simulations. Finally the 30 results due to the 30 points are returned to Matlab. 

· Styrene_Plant_Optimization_v7 = it is the final GAMS file used for the optimization. The final mathematical model is presented in 
Appendix  A. As the problem is multi-objective (F&EI and TAC), the epsilon-contraint method has been used (see Figure 2). This method is 
explained in apart 3.4 of pdf. 

