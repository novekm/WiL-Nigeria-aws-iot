/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React from 'react';
// eslint-disable-next-line no-unused-vars
import { Route, Routes, Link, useParams } from 'react-router-dom';

// - CORE COMPONENTS -
// AMPLIFY
import { Amplify, Auth } from 'aws-amplify';
import { withAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import { AmplifyConfig } from '../config/amplify-config'; // NO TOUCHY
Amplify.configure(AmplifyConfig);
// PAGES
import Dashboard from './Dashboard';
import IoTDevices from './MyIoTDevices';
import SingleIoTDevice from './SingleIoTDevice';
import GettingStarted from './GettingStarted';
import ErrorPage from './ErrorPage';
import FetchUserDetails from '../common/components/FetchUserDetails';

// Unused imports
// import DataUploader from './DataUploader';
// import AccountSettings from './AccountSettings';
// import S3Objects from './S3Objects';

// Styles
import '@cloudscape-design/global-styles/index.css';

// Uncomment line below for debugging
// Amplify.Logger.LOG_LEVEL = 'DEBUG';
Auth.currentCredentials().then((info) => {
  const cognitoIdentityId = info.identityId;
  console.log('Cognito Identity ID:', cognitoIdentityId);
});

// eslint-disable-next-line react/prop-types
const App = ({ signOut, user }) => {
  // let { userId } = useParams();
  return (
    <>
      <FetchUserDetails user={user} signOut={signOut} />
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/iot-devices/" element={<IoTDevices />} />
        <Route path="/iot-devices/:DeviceId" element={<SingleIoTDevice />} />
        <Route path="/getting-started" element={<GettingStarted />} />
        <Route path="*" element={<ErrorPage />} />
        {/* UNUSED ROUTES */}
        {/* <Route path="/data-uploader" element={<DataUploader />} /> */}
        {/* <Route path="/account-settings" element={<AccountSettings />} /> */}
      </Routes>
    </>
  );
};

// export default App;
export default withAuthenticator(App);
