// Perfect Pitch in Rust

// Imports
use std::collections::HashMap;

// Define constants
const PITCH_CLASSES: [u8; 12] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

// Pitch Detection function
fn detect_pitch(input: &[i16]) -> i16 {
    let mut pitch_counts = HashMap::new();

    // Count the number of times each pitch class (c, c#, d, etc) occurs
    for sample in input {
        let pitch_class = (*sample % 12) as u8;
        let count = pitch_counts.entry(pitch_class).or_insert(0);
        *count += 1;
    }

    // Find the pitch class with the highest frequency
    let mut highest_frequency = 0;
    let mut highest_pitch_class = 0;
    for pitch_class in PITCH_CLASSES.iter() {
        let count = pitch_counts.get(pitch_class).unwrap_or(&0);
        if *count > highest_frequency {
            highest_frequency = *count;
            highest_pitch_class = *pitch_class;
        }
    }

    // Return the pitch class with the highest frequency
    highest_pitch_class as i16
}

// Pitch Shifting function
fn shift_pitch(input: &[i16], shift_amount: i8) -> Vec<i16> {
    let mut output = Vec::new();

    // Shift the pitch of each sample
    for sample in input {
        let shifted_sample = *sample + (shift_amount as i16);
        output.push(shifted_sample);
    }

    output
}

// Pitch Correction function
fn correct_pitch(input: &[i16]) -> Vec<i16> {
    // Detect the pitch of the input
    let detected_pitch = detect_pitch(input);

    // Shift the input so the pitch is correct
    let shift_amount = 0 - detected_pitch;
    let shifted_input = shift_pitch(input, shift_amount);

    shifted_input
}

// Test input
let test_input = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

// Test detect_pitch function
let detected_pitch = detect_pitch(&test_input);
assert_eq!(detected_pitch, 0);

// Test shift_pitch function
let shifted_pitch = shift_pitch(&test_input, 2);
assert_eq!(shifted_pitch, vec![3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);

// Test correct_pitch function
let corrected_pitch = correct_pitch(&test_input);
assert_eq!(corrected_pitch, vec![-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0]);