version 1.0

task text_to_file {
    input {
        String text
        String filepath
    }
    command {
        mkdir -p $( dirname ~{filepath} )
        echo '~{text}' > ~{filepath}
    }
    output {
        File text_file = filepath
    }
    runtime {
        docker: "us.gcr.io/broad-dsde-cromwell-dev/centaur/ubuntu:12022020-for-cromwell-tests"
    }
}

workflow Gutenberg {
    call text_to_file as set_type {
        input:
            text="The type is set, let us print something",
            filepath="typeset.txt"
    }
    call text_to_file as great_press {
        input:
            text="This press is working great!",
            filepath="typeset.txt"
    }
    output {
        File typeset = set_type.text_file
        File press_is_great = great_press.text_file
    }
}
