/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import { StatusBar, useColorScheme } from 'react-native';
import { WidgetSettings } from './src/screens/WidgetSettings';
import { useWidgetSettings } from './src/hooks/useWidgetSettings';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';
  const { settings, updateSetting } = useWidgetSettings();

  return (
    <>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={isDarkMode ? '#000' : '#fff'}
      />
      <WidgetSettings />
    </>
  );
};

export default App;
