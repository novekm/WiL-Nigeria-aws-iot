// import { util } from '@aws-appsync/utils';
// import * as ddb from '@aws-appsync/utils/dynamodb'
// export function request(ctx) {
//   return {
//     operation: 'GetItem',
//     key: util.dynamodb.toMapValues({ MessageId: ctx.args.MessageId }),
//   };
// }

// export function response(ctx) {
//   return ctx.result
// }

import * as ddb from '@aws-appsync/utils/dynamodb'

export function request(ctx) {
	return ddb.get({ key: { MessageId: ctx.args.MessageId } })
}

export const response = (ctx) => ctx.result
