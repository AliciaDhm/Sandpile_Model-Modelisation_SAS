
Sandpile-Modeling-SOC
Modeling Self-Organized Criticality (Bak–Tang–Wiesenfeld Sandpile) with SAS

This project studies Self-Organized Criticality (SOC) through the Bak–Tang–Wiesenfeld (BTW) sandpile model. It includes an intuitive implementation, an optimized implementation, and a random-driven version used to study avalanche statistics and 1/f-type behavior. The PDF report explains the theory, algorithms, and results.

## Objective
- Present the BTW sandpile model and the SOC concept
- Implement sandpile dynamics in SAS (IML)
- Compare an intuitive vs optimized implementation
- Simulate a random-driven model and analyze avalanche size/duration distributions

## Repository structure
```text
.
├─ Code/
│  ├─ The_intuitive_version_Sandpile.sas
│  ├─ The_optimised_version.sas
│  └─ Random_Sandpile_code.sas
└─ Sandpile.pdf
```

## Notes

- The intuitive version may run slowly for large grids due to nested loops.
- The optimized version reduces loops and is recommended for large simulations.
- The full explanations, parameters, and results are documented in `Sandpile.pdf`.
