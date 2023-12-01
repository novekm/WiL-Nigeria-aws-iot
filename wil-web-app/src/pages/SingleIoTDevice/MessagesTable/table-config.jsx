import * as React from 'react';
import { Link } from '@cloudscape-design/components';

export function getMatchesCountText(count) {
  return count === 1 ? `1 match` : `${count} matches`;
}

// function formatDate(date) {
//   const dateFormatter = new Intl.DateTimeFormat('en-US', { dateStyle: 'long' });
//   const timeFormatter = new Intl.DateTimeFormat('en-US', { timeStyle: 'short', hour12: false });
//   return `${dateFormatter.format(date)}, ${timeFormatter.format(date)}`;
// }

// function createLabelFunction(columnName) {
//   return ({ sorted, descending }) => {
//     const sortState = sorted ? `sorted ${descending ? 'descending' : 'ascending'}` : 'not sorted';
//     return `${columnName}, ${sortState}.`;
//   };
// }

export const columnDefinitions = [
  // {
  //   id: 'Timestamp',
  //   header: 'Timestamp',
  //   cell: item => <Link href={`#${item.Timestamp}`}>{item.Timestamp}</Link>,
  //   ariaLabel: createLabelFunction('Timestamp'),
  //   sortingField: 'Timestamp',
  //   isRowHeader: true,
  // },
  {
    id: 'Timestamp',
    header: 'Timestamp',
    cell: (item) => item.Timestamp,
    // ariaLabel: createLabelFunction('Timestamp'),
    sortingField: 'Timestamp'
  },
  // {
  //   id: 'Timestamp',
  //   header: 'Timestamp',
  //   cell: (item) => formatDate(item.Timestamp),
  //   ariaLabel: createLabelFunction('Last modified'),
  //   sortingComparator: (a, b) => a.Timestamp.valueOf() - b.Timestamp.valueOf(),
  // },
  {
    id: 'Message',
    header: 'Message',
    cell: (item) => item.Message,
    // ariaLabel: createLabelFunction('Message'),
    sortingField: 'Message',
  },
];

export const paginationLabels = {
  nextPageLabel: 'Next page',
  pageLabel: pageNumber => `Go to page ${pageNumber}`,
  previousPageLabel: 'Previous page',
};

const pageSizePreference = {
  title: 'Select page size',
  options: [
    { value: 10, label: '10 messages' },
    { value: 20, label: '20 messages' },
    { value: 30, label: '30 messages' },
  ],
};

const visibleContentPreference = {
  title: 'Select visible content',
  options: [
    {
      label: 'Main properties',
      options: columnDefinitions.map(({ Timestamp, header }) => ({ Timestamp, label: header, editable: Timestamp !== 'Timestamp' })),
    },
  ],
};
export const collectionPreferencesProps = {
  pageSizePreference,
  visibleContentPreference,
  cancelLabel: 'Cancel',
  confirmLabel: 'Confirm',
  title: 'Preferences',
};
