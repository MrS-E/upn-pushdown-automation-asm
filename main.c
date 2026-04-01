#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int evaluate_upn_asm(const char *input, int mode, long *result);

void step_dump(const long *sp, const long *empty_sp) {
   printf("Keller: [");

   if (sp != empty_sp) {
      const long *p = empty_sp - 1;
      int first = 1;

      while (1) {
         if (!first) {
            printf(", ");
         }
         printf("%ld", *p);
         first = 0;

         if (p == sp) {
            break;
         }
         --p;
      }
   }

   printf("]\n");
   fflush(stdout);
   sleep(1);
}

static void usage(const char *prog) {
   fprintf(stderr, "Usage:\n");
   fprintf(stderr, "  %s run  \"23+4*\"\n", prog);
   fprintf(stderr, "  %s step \"23+4*\"\n", prog);
   fprintf(stderr, "\n");
   fprintf(stderr, "Allowed symbols: digits 0..9, +, *, spaces\n");
}

int main(int argc, char **argv) {
   if (argc != 3) {
      usage(argv[0]);
      return 1;
   }

   int mode;
   if (strcmp(argv[1], "run") == 0) {
      mode = 0;
   } else if (strcmp(argv[1], "step") == 0) {
      mode = 1;
   } else {
      usage(argv[0]);
      return 1;
   }

   long result = 0;
   int ok = evaluate_upn_asm(argv[2], mode, &result);

   if (ok) {
      printf("Resultat: %ld\n", result);
      return 0;
   } else {
      printf("Kein akzeptiertes Eingabewort.\n");
      return 1;
   }
}