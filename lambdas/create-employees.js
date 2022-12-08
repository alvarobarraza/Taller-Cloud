const AWS = require("aws-sdk"); // using the SDK
const EMPLOYEES_TABLE = process.env.EMPLOYEES_TABLE; // obtaining the table name

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
 // create a new object

 const body = event.body;
 const newEmployees = {
   ...body,
   employeesId: Date.now().toString(),
   expiryPeriod: Date.now().toString(), // specify TTL
 };
  
 // insert it to the table

 await documentClient
   .put({
     TableName: EMPLOYEES_TABLE,
     Item: newEmployees,
    })
   .promise();
    
 // return the created object

 return {statusCode: 200,body: JSON.stringify(newEmployees), 
 }; 
};
