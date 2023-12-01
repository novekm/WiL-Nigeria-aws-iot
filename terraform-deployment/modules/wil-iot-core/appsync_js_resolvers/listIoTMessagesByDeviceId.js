// // Recommended approach to handle an object of values
// import { util } from '@aws-appsync/utils';
// export function request(ctx) {
//   const DeviceId = ctx.source.DeviceId; // passed from parent
//   const query = JSON.parse(
//     util.transform.toDynamoDBConditionExpression({ DeviceId: { eq: DeviceId } })
//   );
//   return {
//     operation: 'Query', query,
//     // filter: filter ? JSON.parse(util.transform.toDynamoDBFilterExpression(filter)) : null,
//     // limit: limit ?? 50,
//     // nextToken,
//   };
// }

// export function response(ctx) {
//   const { items: IoTMessages = [] } = ctx.result
//   return { IoTMessages }
// }


import * as ddb from '@aws-appsync/utils/dynamodb';

export function request(ctx) {
  const { limit = 1000, nextToken, DeviceId } = ctx.arguments;
  return ddb.query({
    index: 'DeviceIdIndex',
    // var.iot_global_secondary_index_name
    query: { DeviceId: { eq: DeviceId } },
    limit,
    nextToken,
  });
}

export function response(ctx) {
  const { items: messages = [], nextToken } = ctx.result;
  return { messages, nextToken };
}
