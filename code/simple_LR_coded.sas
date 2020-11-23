/*Logistical regression model check*/
data arthrits;                                                                                                                          
  input sex$ trtment$ improve$ count;                                                                                                   
  _treat_=(trtment='Active');                                                                                                           
  _sex_  =(sex='F');                                                                                                                    
  better =(improve='some');
/* some means improve, none means not improve*/
cards;                                                                                                                                  
F Active  none  6                                                                                                                       
M Active  none  7                                                                                                                       
F Active  some 21                                                                                                                       
M Active  some  7                                                                                                                       
F Placebo none 19                                                                                                                       
M Placebo none 10                                                                                                                       
F Placebo some 13                                                                                                                       
M Placebo some  1                                                                                                                       
;   
run; 
                                                                                                                                        
proc logistic data=arthrits descending;                                                                                                 
  freq count;                                                                                                                           
  model better = _sex_ _treat_ / scale=none aggregate;                                                                                  
run;                                                                                                                                    
                                                       
