#!/usr/bin/env bun
/**
 * Test script to verify tmux escape sequence wrapping
 */

function TMUX_WRAP(sequence: string): string {
  // Double all ESC characters in the sequence
  const escaped = sequence.replace(/\x1B/g, '\x1B\x1B');
  return `\x1BPtmux;\x1B${escaped}\x1B\\`;
}

function GFX(strings: TemplateStringsArray, ...args: any[]) {
  let ret = '\x1B_G';
  for (let n = 0; n < strings.length; n++) {
    ret += strings[n];
    if (n < args.length) ret += args[n];
  }
  return ret + '\x1B\\';
}

// Test graphics command
const testCmd = GFX`a=q,i=1`;
console.log('Original:', JSON.stringify(testCmd));
console.log('Wrapped:', JSON.stringify(TMUX_WRAP(testCmd)));

// Test with actual values
const wrapped = TMUX_WRAP(testCmd);
console.log('\nExpected format:');
console.log('\\x1BPtmux;\\x1B\\x1B\\x1B_Ga=q,i=1\\x1B\\x1B\\\\\\x1B\\\\');
console.log('\nActual output:');
console.log(wrapped.split('').map(c => {
  const code = c.charCodeAt(0);
  if (code === 0x1B) return '\\x1B';
  if (code === 0x5C) return '\\\\';
  if (code < 32) return `\\x${code.toString(16).padStart(2, '0')}`;
  return c;
}).join(''));
