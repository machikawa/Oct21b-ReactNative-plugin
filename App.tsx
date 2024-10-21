import React, {useState} from 'react';
import {View, Text, TextInput, Button, StyleSheet} from 'react-native';
import MCReactModule from 'react-native-marketingcloudsdk';

const EncouragementApp = () => {
  // 2つの入力ボックス用のstate
  const [text1, setText1] = useState('');
  const [text2, setText2] = useState('');
  const [result, setResult] = useState('');

  // ボタンを押したときに実行される関数
  const handleEncouragement = () => {
    setResult(`${text1}と${text2}、がんばれ!!2３！💪`);
    console.log(MCReactModule.isPushEnabled);
    var retval = MCReactModule.enablePush;
    console.log(retval);
    console.log('これ');
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        placeholder="1つ目の入力"
        value={text1}
        onChangeText={setText1}
      />
      <TextInput
        style={styles.input}
        placeholder="2つ目の入力"
        value={text2}
        onChangeText={setText2}
      />
      <Button title="応援する" onPress={handleEncouragement} />
      {result !== '' && <Text style={styles.result}>{result}</Text>}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    paddingHorizontal: 10,
    width: '80%',
  },
  result: {
    marginTop: 20,
    fontSize: 18,
    color: 'blue',
  },
});

export default EncouragementApp;
