const AWS = require("aws-sdk");
const EMPLOYEES_TABLE = process.env.EMPLOYEES_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
 const allEmployees = await documentClient
   .scan({
     TableName: EMPLOYEES_TABLE,
   }).promise();
    
   const { Items = [] } = allEmployees;
   return {
       statusCode: 200,
       body: JSON.stringify(Items),
    };
};
