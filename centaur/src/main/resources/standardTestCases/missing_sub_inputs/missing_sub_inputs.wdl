# In this test we call a sub-workflow without providing it the required inputs and
# we check that the workflow should fail with a proper error message.

import "missing_sub_inputs_import.wdl" as sub_inputs

task tail {
   File inFile
   command {
      tail ${inFile}
   }
   output {
     String tailOut = read_string(stdout())
   }
   runtime { docker: "us.gcr.io/broad-dsde-cromwell-dev/centaur/ubuntu:12022020-for-cromwell-tests" }
}

workflow missing_inputs {
   File x
   call sub_inputs {}
   output {
      sub_inputs.*
   }
}
