const AWS = require("aws-sdk");
const EMPLOYEES_TABLE = process.env.EMPLOYEES_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
 const id = event.body.id;
 await documentClient
   .delete({
     TableName: EMPLOYEES_TABLE,
     Key: {
       employeesId: id,
     },
   }).promise();
      
 return {
   statusCode: 200,
   body: JSON.stringify({ message: "Item Deleted" }),
 };
};
