/* eslint-disable react/jsx-props-no-spreading */
/* eslint-disable no-console */
/* eslint-disable no-use-before-define */
/* eslint-disable react/prop-types */
/* eslint-disable import/no-cycle */
/* eslint-disable no-unused-vars */
/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */

import React, { useState, useEffect } from 'react';
import { useCollection } from '@cloudscape-design/collection-hooks';
import {
  PropertyFilter,
  Pagination,
  Table,
} from '@cloudscape-design/components';

import { API, graphqlOperation } from 'aws-amplify';
import {
  listIoTDevices,
  getIoTDevice,
} from '../../../graphql/queries';
// import { deleteIoTDevice } from '../../../graphql/mutations';

import { getFilterCounterText } from '../../../common/resources/tableCounterStrings';
import { FullPageHeader, MyIoTDevicesTableEmptyState } from '../index';
import {
  CustomAppLayout,
  Navigation,
  TableNoMatchState,
  Notifications,
} from '../../../common/common-components-config';
import { paginationLabels, transcriptSelectionLabels } from '../labels';
import {
  FILTERING_PROPERTIES,
  PROPERTY_FILTERING_I18N_CONSTANTS,
  DEFAULT_PREFERENCES,
  Preferences,
} from './table-property-filter-config';

import '../../../common/styles/base.scss';
import { useLocalStorage } from '../../../common/resources/localStorage';

import { useTCAJobs, useTCAJobsPropertyFiltering } from './hooks';

const IoTDevicesTable = ({ updateTools, saveWidths, columnDefinitions }) => {
  // Below are variables declared to maintain the table's state.
  // Each declaration returns two values: the first value is the current state, and the second value is the function that updates it.
  // They use the general format: [x, setX] = useState(defaultX), where x is the attribute you want to keep track of.
  // For more info about state variables and hooks, see https://reactjs.org/docs/hooks-state.html.

  const [iotDevices, setIoTDevices] = useState([]);
  // const [selectedTranscripts, setSelectedTranscripts] = useState([]);

  const [distributions, setDistributions] = useState([]);
  const [preferences, setPreferences] = useLocalStorage(
    'React-IoTDevices-Table-Preferences',
    DEFAULT_PREFERENCES
  );
  // const [preferences, setPreferences] = useState(DEFAULT_PREFERENCES);
  const [loading, setLoading] = useState(true);

  // a utility to handle operations on the data set (such as filtering, sorting and pagination)
  const {
    items,
    actions,
    filteredItemsCount,
    collectionProps,
    paginationProps,
    propertyFilterProps,
  } = useCollection(iotDevices, {
    propertyFiltering: {
      filteringProperties: FILTERING_PROPERTIES,
      empty: <MyIoTDevicesTableEmptyState resourceName="IoT Devices" />,
      noMatch: (
        <TableNoMatchState
          onClearFilter={() => {
            actions.setPropertyFiltering({ tokens: [], operation: 'and' });
          }}
        />
      ),
    },
    pagination: { pageSize: preferences.pageSize },
    sorting: { defaultState: { sortingColumn: columnDefinitions[0] } },
    selection: {},
  });

  useEffect(() => {
    fetchIoTDevices();
  }, []);

  const fetchIoTDevices = async () => {
    try {
      const IoTDeviceData = await API.graphql(
        graphqlOperation(listIoTDevices, { limit: 10000 })
      );
      const IoTDeviceDataList = IoTDeviceData.data.listIoTDevices.devices;
      console.log('IoT Devices List', IoTDeviceDataList);
      setIoTDevices(IoTDeviceDataList);
      setLoading(false);
    } catch (error) {
      console.log('error on fetching IoT Devices', error);
    }
  };

  return (
    <Table
      {...collectionProps}
      items={items}
      columnDefinitions={columnDefinitions}
      visibleColumns={preferences.visibleContent}
      ariaLabels={transcriptSelectionLabels}
      selectionType="multi"
      variant="full-page"
      stickyHeader
      resizableColumns
      wrapLines={preferences.wrapLines}
      onColumnWidthsChange={saveWidths}
      header={
        <FullPageHeader
          selectedItems={collectionProps.selectedItems}
          totalItems={iotDevices}
          updateTools={updateTools}
          serverSide={false}
        />
      }
      loading={loading}
      loadingText="Loading IoT Devices..."
      filter={
        <PropertyFilter
          i18nStrings={PROPERTY_FILTERING_I18N_CONSTANTS}
          {...propertyFilterProps}
          countText={getFilterCounterText(filteredItemsCount)}
          expandToViewport
        />
      }
      pagination={
        <Pagination {...paginationProps} ariaLabels={paginationLabels} />
      }
      preferences={
        <Preferences
          preferences={preferences}
          setPreferences={setPreferences}
        />
      }
    />
  );
};

export default IoTDevicesTable;
