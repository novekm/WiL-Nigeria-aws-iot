/* eslint-disable no-sequences */
/* eslint-disable jsx-a11y/anchor-is-valid */
/* eslint-disable react/prop-types */
import React from 'react';
import {
  CollectionPreferences,
  // StatusIndicator,
  Link,
} from '@cloudscape-design/components';
import { addColumnSortLabels } from '../labels';

export const COLUMN_DEFINITIONS = addColumnSortLabels([
  {
    id: 'DeviceName',
    cell: (item) => (
      <Link href={`/iot-devices/${item.DeviceId}`}>{item.DeviceName}</Link>
    ),
    header: 'Device Name',
    minWidth: 120,
    maxWidth: 200,
    sortingField: 'DeviceName',
  },
  {
    id: 'DeviceId',
    header: 'Device Id',
    cell: (item) => item.DeviceId,
    minWidth: 200,
    sortingField: 'DeviceId',
  },
  {
    id: 'DeviceStatus',
    header: 'Device Status',
    cell: (item) => item.DeviceStatus,
    minWidth: 160,
    maxWidth: 200,
    sortingField: 'DeviceStatus',
  },
  // {
  //   id: 'Battery',
  //   header: 'Battery',
  //   cell: (item) => item.Battery,
  //   minWidth: 100,
  //   maxWidth: 100,
  //   sortingField: 'Battery',
  // },

  {
    id: 'ShortName',
    header: 'Short Name',
    cell: (item) => item.ShortName,
    minWidth: 100,
    sortingField: 'ShortName',
  },
  {
    id: 'Manufacturer',
    header: 'Manufacturer',
    cell: (item) => item.Manufacturer,
    minWidth: 100,
    sortingField: 'Manufacturer',
  },
  {
    id: 'Model',
    header: 'Model',
    cell: (item) => item.Model,
    minWidth: 100,
    sortingField: 'Model',
  },
  {
    id: 'Device',
    header: 'Device',
    cell: (item) => item.Device,
    minWidth: 100,
    sortingField: 'Device',
  },
  {
    id: 'ComputerModule',
    header: 'Computer Module',
    cell: (item) => item.ComputerModule,
    minWidth: 100,
    sortingField: 'ComputerModule',
  },
  {
    id: 'RegisteredOwner',
    header: 'Registered Owner',
    cell: (item) => item.RegisteredOwner,
    minWidth: 100,
    sortingField: 'RegisteredOwner',
  },
  {
    id: 'PrimaryLocation',
    header: 'PrimaryLocation',
    cell: (item) => item.PrimaryLocation,
    minWidth: 100,
    sortingField: 'PrimaryLocation',
  },



  // This eventually could be used for error handling
  // Could maybe have State of 'Verified', 'Unverified', 'Failed', etc. to give more info
  // {
  //   id: 'JobStatus',
  //   header: 'Job Status',
  //   //  cell: item => item.JobStatus,
  //   cell: (item) => (
  //     item.JobStatus,
  //     (
  //       <StatusIndicator type={item.state === 'Disabled' ? 'error' : 'success'}>
  //         {' '}
  //         {item.state}
  //         {item.JobStatus}
  //       </StatusIndicator>
  //     )
  //   ),
  //   minWidth: 100,
  //   sortingField: 'JobStatus',
  // },
]);

export const PAGE_SIZE_OPTIONS = [
  { value: 10, label: '10 IoT Devices' },
  { value: 30, label: '30 IoT Devices' },
  { value: 50, label: '50 IoT Devices' },
];

export const FILTERING_PROPERTIES = [
  {
    propertyLabel: 'Device Name',
    key: 'DeviceName',
    groupValuesLabel: 'Device Name values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Device Id',
    key: 'DeviceId',
    groupValuesLabel: 'DeviceId values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Device Status',
    key: 'DeviceStatus',
    groupValuesLabel: 'Device Status values',
    operators: [':', '!:', '=', '!='],
  },
  // {
  //   propertyLabel: 'Battery',
  //   key: 'Battery',
  //   groupValuesLabel: 'Battery values',
  //   operators: [':', '!:', '=', '!='],
  // },
  {
    propertyLabel: 'Short Name',
    key: 'ShortName',
    groupValuesLabel: 'Short Name values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Manufacturer',
    key: 'Manufacturer',
    groupValuesLabel: 'Manufacturer values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Model',
    key: 'Model',
    groupValuesLabel: 'Model values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Device',
    key: 'Device',
    groupValuesLabel: 'Device values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Computer Module',
    key: 'ComputerModule',
    groupValuesLabel: 'Computer Module values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Registered Owner',
    key: 'RegisteredOwner',
    groupValuesLabel: 'Registered Owner values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Primary Location',
    key: 'PrimaryLocation',
    groupValuesLabel: 'Primary Location values',
    operators: [':', '!:', '=', '!='],
  },

];

export const PROPERTY_FILTERING_I18N_CONSTANTS = {
  filteringAriaLabel: 'your choice',
  dismissAriaLabel: 'Dismiss',

  filteringPlaceholder: 'Search',
  groupValuesText: 'Values',
  groupPropertiesText: 'Properties',
  operatorsText: 'Operators',

  operationAndText: 'and',
  operationOrText: 'or',

  operatorLessText: 'Less than',
  operatorLessOrEqualText: 'Less than or equal',
  operatorGreaterText: 'Greater than',
  operatorGreaterOrEqualText: 'Greater than or equal',
  operatorContainsText: 'Contains',
  operatorDoesNotContainText: 'Does not contain',
  operatorEqualsText: 'Equals',
  operatorDoesNotEqualText: 'Does not equal',

  editTokenHeader: 'Edit filter',
  propertyText: 'Property',
  operatorText: 'Operator',
  valueText: 'Value',
  cancelActionText: 'Cancel',
  applyActionText: 'Apply',
  allPropertiesLabel: 'All properties',

  tokenLimitShowMore: 'Show more',
  tokenLimitShowFewer: 'Show fewer',
  clearFiltersText: 'Clear filters',
  removeTokenButtonAriaLabel: () => 'Remove token',
  enteredTextLabel: (text) => `Use: "${text}"`,
};
export const CUSTOM_PREFERENCE_OPTIONS = [
  { value: 'table', label: 'Table' },
  { value: 'cards', label: 'Cards' },
];
export const DEFAULT_PREFERENCES = {
  pageSize: 30,
  visibleContent: [
    'DeviceName',
    'DeviceId',
    'DeviceStatus',
    // 'Battery',
    'ShortName',
    'Model',
    'Device',
    'ComputerModule',
    'RegisteredOwner',
    'PrimaryLocation',
  ],
  wraplines: false,
  custom: CUSTOM_PREFERENCE_OPTIONS[0].value,
};

export const VISIBLE_CONTENT_OPTIONS = [
  {
    label: 'Main IoT Devices Table properties',
    options: [
      { id: 'DeviceName', label: 'Device Name', editable: false },
      { id: 'DeviceId', label: 'Device ID', editable: true },
      { id: 'DeviceStatus', label: 'Device Status', editable: true },
      // { id: 'Battery', label: 'Battery', editable: true },
      { id: 'ShortName', label: 'Short Name', editable: true },
      { id: 'Manufacturer', label: 'Manufacturer', editable: true },
      { id: 'Model', label: 'Model', editable: true },
      { id: 'Device', label: 'Device', editable: true },
      { id: 'ComputerModule', label: 'ComputerModule', editable: true },
      { id: 'RegisteredOwner', label: 'RegisteredOwner', editable: true },
      { id: 'PrimaryLocation', label: 'PrimaryLocation', editable: true },
      // { id: 'CreatedAt', label: 'Created At', editable: true },
    ],
  },
];
export const Preferences = ({
  preferences,
  setPreferences,
  disabled,
  pageSizeOptions = PAGE_SIZE_OPTIONS,
  visibleContentOptions = VISIBLE_CONTENT_OPTIONS,
}) => (
  <CollectionPreferences
    title="Preferences"
    confirmLabel="Confirm"
    cancelLabel="Cancel"
    disabled={disabled}
    preferences={preferences}
    onConfirm={({ detail }) => setPreferences(detail)}
    pageSizePreference={{
      title: 'Page size',
      options: pageSizeOptions,
    }}
    wrapLinesPreference={{
      label: 'Wrap lines',
      description: 'Check to see all the text and wrap the lines',
    }}
    visibleContentPreference={{
      title: 'Select visible columns',
      options: visibleContentOptions,
    }}
  />
);
