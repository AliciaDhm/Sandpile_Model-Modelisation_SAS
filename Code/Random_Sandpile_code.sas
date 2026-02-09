proc iml;
   /* paramètres */
   n = 50;                            
   Ngrains = 200000;                  
   Tas = j(n, n, 0);                   

   /* vecteurs de stockage */
   Size = j(1, Ngrains, 0);          /* number of affected sites */
   Time  = j(1, Ngrains, 0);        /* duration ( number of iterations before stability ) */

   do i = 1 to Ngrains;

      /* random deposition */
      r = ceil(n * rand("Uniform"));
      c = ceil(n * rand("Uniform"));
      Tas[r, c] = Tas[r, c] + 1;

      /* stabilization */
      do while (max(Tas) >= 4);
         idx = loc(Tas >= 4);
         if ncol(idx) = 0 then leave;

      /* variable storage */
      Size[i] = Size[i] + ncol(idx);       /* number of avalanches  */
      Time[i]  = Time[i] + 1;      /* avalanche duration */
         rr = ceil(idx / n);
         cc = idx - (rr - 1)*n;

         /* simultaneous removal */
         do k = 1 to ncol(idx);
            Tas[rr[k], cc[k]] = Tas[rr[k], cc[k]] - 4;
         end;

         /* simultaneous redistribution */
         Add = j(n, n, 0);
         do k = 1 to ncol(idx);
            r = rr[k]; c = cc[k];
            if r > 1  then Add[r-1, c] = Add[r-1, c] + 1;
            if r < n  then Add[r+1, c] = Add[r+1, c] + 1;
            if c > 1  then Add[r, c-1] = Add[r, c-1] + 1;
            if c < n  then Add[r, c+1] = Add[r, c+1] + 1;
         end;

         Tas = Tas + Add;              /* simultaneous update */
      end;

   end;

   /* final visualization  */
   Sandpile = mod(Tas, 4);
   call heatmapdisc(Sandpile)
        xvalues=1:n yvalues=1:n
        title="Abelian Sandpile (aléatoire)"
        displayoutlines=0;


Size_pos = Size[loc(Size > 0)]; /* to filter out size = 0 */
call tabulate(valueS, countS, Size_pos);
frequencyS = countS/sum(countS);

log_freq_size = log(countS/sum(countS));
log_size = log(valueS);

Time_pos = Time[loc(Time > 0)]; /* to filter out initial Time = 0 */
call tabulate(valueT, countT, Time_pos);
frequencyT = countT/sum(countT);

/* export tables as datasets */

/* for size */
create log_size_distribution var {"valueS" "frequencyS" "log_size" "log_freq_size"};
append;
close log_size_distribution;

/* for duration */
create log_time_distribution var {"valueT" "frequencyT"};
append;
close log_time_distribution;


title "Frequency of avalanche sizes";
call histogram(Size)scale='PROPORTION';

title "Frequency of avalanche durations ( number of iterations before stability )";
call histogram(Time)scale='PROPORTION';

quit;

/* Distribution log-log des tailles d’avalanche (1/f noise) */
proc sgplot data=log_size_distribution;
scatter x=valueS y=frequencyS / markerattrs = (symbol=circlefilled);
xaxis type=log label="Avalanche size" grid;
yaxis type=log label="Frequency of size" grid;
title "Log-log distribution of avalanche sizes (1/f noise )";
run;

/* Distribution log-log du temps des avalanches */
proc sgplot data=log_time_distribution;
   scatter x=valueT y=frequencyT / markerattrs = (symbol=circlefilled);
   xaxis type=log label="Time" grid;
   yaxis type=log label="Frequency of time" grid;
   title "Log-log distribution of avalanche durations";
run;

/* La regression */
proc reg data=log_size_distribution(where=(log_Size <= 5));
   model log_freq_size = log_size;
run;
