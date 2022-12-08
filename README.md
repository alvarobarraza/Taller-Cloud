# Taller-Cloud

TALLER CLOUD FINAL - ALVARO BARRAZA- JESUS MONTERO


1.Requisitos previos: Tener configurado el perfil de AWS, tener instalado terraform y creamos nuestra carpeta con el archivo main.tf, Usaremos este archivo para definir el proveedor (complemento para administrar los recursos de la nube con Terraform) y conectar Terraform a nuestra cuenta de AWS.
![image](https://user-images.githubusercontent.com/62623557/206588238-dad80193-72be-41f7-82c2-fb83ba407ec3.png)

2. Después de agregar este fragmento, inicie una terminal en el directorio activo y ejecute terraform init. Inicializará el directorio de configuración e instalará el proveedor requerido (AWS) en su dispositivo.
![image](https://user-images.githubusercontent.com/62623557/206588255-816276ea-5d16-4e4e-8b62-266c066d950c.png)

3. A continuacion definimos la tabla de DynamoDB, Ejecutamos terraform plan: Esto mostrará los cambios pendientes. Ejecutamos terraform apply: Esto aprovisionará sus recursos.
![image](https://user-images.githubusercontent.com/62623557/206588279-2c1d7a5f-bb1f-4844-8e9c-b66afb110560.png)
![image](https://user-images.githubusercontent.com/62623557/206588294-3657d076-d828-47b5-948f-3002215d2a2b.png)

4. configuramos un tiempo de caducidad para su elemento de datos, se debe configurar el tiempo de vida. Para hacerlo, agregue el ttl atributo a su declaración de tabla, Para asegurarse de que sus datos se puedan restaurar en caso de un desastre, puede habilitar la Recuperación en un punto en el tiempo. Estas son copias de seguridad continúas creadas por DynamoDB para su tabla (cuando están habilitadas). 
Fuera de la caja, DynamoDB encripta sus datos como resto. Terraform le permite configurar la clave KMS utilizada para el cifrado. Así como se muestra a continuación:
![image](https://user-images.githubusercontent.com/62623557/206588383-73ad12a2-d7ee-4fbc-a812-fe1f8ab998bb.png)

5. Definición de roles de ejecución y políticas de IAM y ejecutamos npm init
![image](https://user-images.githubusercontent.com/62623557/206588416-eb51816a-ebe9-4256-a34b-da6acad2a9ab.png)

6. Después de crear su tabla, podemos configurar nuestra API usando AWS Lambda para mantener la lógica comercial. Nuestra API constará de tres funciones.
Crear nota
Borrar nota
Obtener todas las notas
![image](https://user-images.githubusercontent.com/62623557/206588434-59906027-5010-4741-8baa-3ce0b4d53c8a.png)
![image](https://user-images.githubusercontent.com/62623557/206588446-10fa3616-3448-4fb0-8269-aeb3951813da.png)
![image](https://user-images.githubusercontent.com/62623557/206588462-4e3044b4-16f8-4196-979e-1cb672b6868e.png)
![image](https://user-images.githubusercontent.com/62623557/206588477-bedf8a39-9396-479f-a963-021b62dd47ea.png)
![image](https://user-images.githubusercontent.com/62623557/206588485-7ce9367c-46ff-44b1-97e8-1a6a42a12d29.png)
Después de agregar las tres funciones Lambda, ejecute un terraform plan y un terraform applypara aprovisionar sus funciones Lambda en la nube.

7. tabla employees DynamoDB
![image](https://user-images.githubusercontent.com/62623557/206588532-2e5eef8c-f1d8-4a7d-9ba7-223d3b08cfcf.png)
![image](https://user-images.githubusercontent.com/62623557/206588538-d744e0a4-1dd2-4975-9040-c40f84e277e1.png)

8. las funciones lambdas AWS
![image](https://user-images.githubusercontent.com/62623557/206588575-4587c5cf-e4ed-43c0-b0b4-242a9bece353.png)

9. API gateway
![image](https://user-images.githubusercontent.com/62623557/206588596-44326c7d-d5ea-459f-894e-b3ddb8b712b3.png)
![image](https://user-images.githubusercontent.com/62623557/206588613-c3c17aeb-5c4c-45ab-84e8-0c3a69ccd7af.png)
![image](https://user-images.githubusercontent.com/62623557/206588621-f53fbfcf-99ac-4d35-bb7b-f5aae9cee89a.png)
![image](https://user-images.githubusercontent.com/62623557/206588628-0f02188f-34c5-4995-a0a1-aadceb02238c.png)

https://gxkartwu61.execute-api.us-east-1.amazonaws.com/employees-api/employees
![image](https://user-images.githubusercontent.com/62623557/206588646-14e943f0-1433-4085-a57c-26546d371b52.png)
