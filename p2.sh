#!/bin/bash
#Arturo Jemmott 8-908-2064 arturo.jemmott@utp.ac.pa

# Inicializacion de variables
ISDONE=1
PTH="$1"
NONPNG=1
HALTEXEC=1
HOME=$(pwd)

echo "Bienvenido al menu inicial del apng-manager."
while [ $ISDONE -ne 0 ] #bucle pincipal del programa
do
    printf "\n[1] Verificar\n[2] Ensamblar\n[3] Crear GIF\n[4] Salir\n"
    printf "¿Qué acción desea realizar? [1/2/3/4] > "
    read selection

    case $selection in #Selector de Opciones del menu
        1) #Opcion Verificar
        printf "\nVerificando las cualidades de los archivos en la ruta:\n"

            if cd "$PTH" #Si la ruta al directorio existe...
            then
                for FILE in * # ...por cada archivo del directorio...
                do
                    #Imprime el tipo de archivo y su tamano en bytes
                    file $FILE 
                    echo "$( wc -c $FILE | egrep -o [[:digit:]]+\ )bytes" 
                    
                    #Identifica si hay un archivo que no es PNG
                    file $FILE | grep -vq PNG
                    NONPNG=$(echo $?)

                    #Muestra el mensaje de error por algun archivo que no es PNG
                    if [ $NONPNG -eq 0 ]
                    then
                        printf "\nEl archivo $FILE en $PTH no es de formato png.\n"
                        echo "Remueva el archivo del directorio y vuelva ejecutar el programa."
                    fi
                    echo ""

                    #Marca que la ejecucion debe deternse una vez termine de revisar los archivos
                    if [ $HALTEXEC -gt 0 -a $NONPNG -eq 0 ]
                    then 
                        HALTEXEC=$NONPNG
                    fi

                done

                #Detiene la ejecucion de ser requerido
                if [ $HALTEXEC -eq 0 ]
                then
                    exit 1
                fi

            else
                #Indica que la ruta no es valida
                echo "la ruta introducida no es válida."
                echo "Vuelva a ejecutar el programa con una ruta válida"
                exit 1
            fi
            cd "$HOME"
        ;;
        2) #Opcion Ensamblar

            #Se introduce el numero de ciclos a animar
            printf "\nEste es el proceso de ensamblado grafico APNG.\n"
            printf "\nCuantos ciclos desea animar?\n > "
            read CYCLCOUNT

            #Por cada salida en una secuencia hasta el numero leido...
            for OUT in $(seq 1 $CYCLCOUNT) 
            do

                # Lee en nombre deseado.
                printf "\n Cual sera el nombre .png del ciclo ${OUT}?\n > "
                read NAME

                # Lee el numerador del intervalo de fotograma 
                printf "\n Introduzca el numerador de las fracciones de segundo de cada fotograma: \n >"
                read NUM

                # Lee el denominador del intervalo de fotograma
                printf "\n Introduzca el denominador de las fracciones de segundo de cada fotograma: \n >"
                read DEN

                #Dirigete al directorio de trabajo y encuentra el primer fotograma
                cd "$PTH" 
                INITFRAME="$(ls | egrep -o .*[[:digit:]]+.*\.png | sort -n | head -n 1)"

                #Crea un animacion apng con el nombre NAME en la carpeta de inicio...
                #...con este INITFRAME como primer fotograma...
                # ...bajo la fraccion de NUM/DEN definida.
                apngasm "${HOME}/${NAME}" "$INITFRAME" "${NUM}/${DEN}" 

            done

            cd "$HOME"
        ;;
        3) #Opcion Crear GIF
            printf "\nIntroduzca la ruta al archivo APNG que quiere convertir:\n > "
            read SOURCE
            apng2gif "$SOURCE"

        ;;
        4) #Opcion Salir
            ISDONE=0
        ;;
    esac
done
