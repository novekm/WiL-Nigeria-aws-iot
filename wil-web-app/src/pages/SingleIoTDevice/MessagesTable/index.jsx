import React, { useState } from 'react';
import { useCollection } from '@cloudscape-design/collection-hooks';
import {
  Box,
  Button,
  CollectionPreferences,
  Header,
  Pagination,
  Table,
  TextFilter,
} from '@cloudscape-design/components';
// import allItems from './data';
import { columnDefinitions, getMatchesCountText, paginationLabels, collectionPreferencesProps } from './table-config';

function EmptyState({ title, subtitle, action }) {
  return (
    <Box textAlign="center" color="inherit">
      <Box variant="strong" textAlign="center" color="inherit">
        {title}
      </Box>
      <Box variant="p" padding={{ bottom: 's' }} color="inherit">
        {subtitle}
      </Box>
      {action}
    </Box>
  );
}

export default function CollectionHooksTable({iotMessages, }) {
  const [preferences, setPreferences] = useState({ pageSize: 10, visibleContent: ['Timestamp', 'Message',] });
  const MESSAGES = [iotMessages] // TODO - change this to prop for all message with filter for DeviceId


  const { items, actions, filteredItemsCount, collectionProps, filterProps, paginationProps } = useCollection(
    MESSAGES[0],
    // allItems,
    {
      filtering: {
        empty: <EmptyState title="No messages"/>,
        noMatch: (
          <EmptyState
            title="No matches"
            action={<Button onClick={() => actions.setFiltering('')}>Clear filter</Button>}
          />
        ),
      },
      pagination: { pageSize: preferences.pageSize },
      sorting: { defaultState: { sortingColumn: columnDefinitions[0], isDescending: true  }, },
      selection: {},
    }
  );
  const { selectedItems } = collectionProps;
  return (
    <Table
      {...collectionProps}
      selectionType="multi"
      header={
        <Header
          counter={selectedItems.length ? `(${selectedItems.length}/${MESSAGES[0].length})` : `(${MESSAGES[0].length})`}
        >
          Messages
        </Header>
      }
      columnDefinitions={columnDefinitions}
      visibleColumns={preferences.visibleContent}
      items={items}
      pagination={<Pagination {...paginationProps} ariaLabels={paginationLabels} />}
      filter={
        <TextFilter
          {...filterProps}
          countText={getMatchesCountText(filteredItemsCount)}
          filteringAriaLabel="Filter messages"
        />
      }
      preferences={
        <CollectionPreferences
          {...collectionPreferencesProps}
          preferences={preferences}
          onConfirm={({ detail }) => setPreferences(detail)}
        />
      }
    />
  );
}
