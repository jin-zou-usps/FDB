#!/usr/bin/env python3
"""
Test module for FDB Query functionality.

This module contains tests to validate the database query functionality
for finding data differences between tables.
"""

import unittest
import tempfile
import os
from fdb_query import FDBQuery


class TestFDBQuery(unittest.TestCase):
    """Test cases for FDBQuery class."""
    
    def setUp(self):
        """Set up test fixture before each test method."""
        self.fdb = FDBQuery()
        self.fdb.create_sample_tables()
        self.fdb.insert_sample_data()
    
    def tearDown(self):
        """Clean up after each test method."""
        self.fdb.close()
    
    def test_database_connection(self):
        """Test that database connection is established."""
        self.assertIsNotNone(self.fdb.connection)
    
    def test_table_creation(self):
        """Test that tables are created successfully."""
        cursor = self.fdb.connection.cursor()
        
        # Check table_a exists
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='table_a'")
        result = cursor.fetchone()
        self.assertIsNotNone(result)
        
        # Check table_b exists
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='table_b'")
        result = cursor.fetchone()
        self.assertIsNotNone(result)
    
    def test_sample_data_insertion(self):
        """Test that sample data is inserted correctly."""
        table_a_data = self.fdb.get_table_contents("table_a")
        table_b_data = self.fdb.get_table_contents("table_b")
        
        self.assertEqual(len(table_a_data), 5)  # 5 records in table A
        self.assertEqual(len(table_b_data), 4)  # 4 records in table B
    
    def test_find_data_not_in_table_b(self):
        """Test finding data in table A but not in table B."""
        results = self.fdb.find_data_not_in_table_b()
        
        # Should find 3 records: banana, date, elderberry
        self.assertEqual(len(results), 3)
        
        # Check specific records
        names = [row[1] for row in results]  # Extract names (column index 1)
        self.assertIn('banana', names)
        self.assertIn('date', names)
        self.assertIn('elderberry', names)
        
        # These should not be in the results (they exist in both tables)
        self.assertNotIn('apple', names)
        self.assertNotIn('cherry', names)
    
    def test_find_data_not_in_table_a(self):
        """Test finding data in table B but not in table A."""
        results = self.fdb.find_data_not_in_table_a()
        
        # Should find 2 records: fig, grape
        self.assertEqual(len(results), 2)
        
        # Check specific records
        names = [row[1] for row in results]  # Extract names (column index 1)
        self.assertIn('fig', names)
        self.assertIn('grape', names)
        
        # These should not be in the results (they exist in both tables)
        self.assertNotIn('apple', names)
        self.assertNotIn('cherry', names)
    
    def test_get_table_contents(self):
        """Test getting table contents."""
        table_a_contents = self.fdb.get_table_contents("table_a")
        table_b_contents = self.fdb.get_table_contents("table_b")
        
        # Verify we get the expected number of records
        self.assertEqual(len(table_a_contents), 5)
        self.assertEqual(len(table_b_contents), 4)
        
        # Verify records are tuples
        self.assertIsInstance(table_a_contents[0], tuple)
        self.assertIsInstance(table_b_contents[0], tuple)
    
    def test_custom_key_columns(self):
        """Test using custom key columns for comparison."""
        # Test with only name column (ignore value)
        results = self.fdb.find_data_not_in_table_b(['name'])
        
        # Should find records where name doesn't exist in table B
        names = [row[1] for row in results]
        self.assertIn('banana', names)
        self.assertIn('date', names)
        self.assertIn('elderberry', names)
    
    def test_empty_tables(self):
        """Test behavior with empty tables."""
        # Create new FDB instance with empty tables
        empty_fdb = FDBQuery()
        empty_fdb.create_sample_tables()
        
        try:
            results = empty_fdb.find_data_not_in_table_b()
            self.assertEqual(len(results), 0)
            
            results = empty_fdb.find_data_not_in_table_a()
            self.assertEqual(len(results), 0)
        finally:
            empty_fdb.close()
    
    def test_file_database(self):
        """Test using a file-based database."""
        # Create a temporary file for testing
        with tempfile.NamedTemporaryFile(delete=False, suffix='.db') as temp_file:
            temp_db_path = temp_file.name
        
        try:
            # Test with file database
            file_fdb = FDBQuery(temp_db_path)
            file_fdb.create_sample_tables()
            file_fdb.insert_sample_data()
            
            results = file_fdb.find_data_not_in_table_b()
            self.assertEqual(len(results), 3)
            
            file_fdb.close()
        finally:
            # Clean up temporary file
            if os.path.exists(temp_db_path):
                os.unlink(temp_db_path)


def run_tests():
    """Run all tests and display results."""
    unittest.main(verbosity=2)


if __name__ == "__main__":
    run_tests()