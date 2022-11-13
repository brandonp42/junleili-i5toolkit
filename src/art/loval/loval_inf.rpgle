     d a               s              4f
      * HUGE
     d huge            s              4f   inz(*hival)
      * INF
     d                 ds
     d c                              4a   inz(x'7F800000')
     d inf                            4f   overlay(c)

      /free
           a = 2 ** 127;  // a = 1.701411834605E+038
           a /= huge;     // a = 5.000000596046E-001 [1]

           a = 2 ** 127;
           a = huge - a;  // a = 1.701411631781E+038 [2]

           a = 2 ** 127;
           a /= inf;      // a = 0.000000000000E+000 [3]

           a = 2 ** 127;
           a = inf - a;   // a = x'7F800000', aka. +INF

           *inlr = *on;
      /end-free
