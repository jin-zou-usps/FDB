#!/usr/bin/env python3
"""
FDB Query Module - Find data that exists in table A but not in table B.

This module provides functionality to query database tables and find records
that exist in one table but not in another.
"""

import sqlite3
import logging
from typing import List, Tuple, Any, Optional

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class FDBQuery:
    """
    A class to handle database queries for finding data differences between tables.
    """
    
    def __init__(self, db_path: str = ":memory:"):
        """
        Initialize the FDB Query with a database connection.
        
        Args:
            db_path (str): Path to SQLite database file. Defaults to in-memory database.
        """
        self.db_path = db_path
        self.connection = None
        self.connect()
    
    def connect(self):
        """Establish database connection."""
        try:
            self.connection = sqlite3.connect(self.db_path)
            self.connection.row_factory = sqlite3.Row
            logger.info(f"Connected to database: {self.db_path}")
        except sqlite3.Error as e:
            logger.error(f"Error connecting to database: {e}")
            raise
    
    def close(self):
        """Close database connection."""
        if self.connection:
            self.connection.close()
            logger.info("Database connection closed")
    
    def create_sample_tables(self):
        """
        Create sample tables A and B for demonstration purposes.
        """
        cursor = self.connection.cursor()
        
        # Create table A
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS table_a (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                value TEXT
            )
        """)
        
        # Create table B
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS table_b (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                value TEXT
            )
        """)
        
        self.connection.commit()
        logger.info("Sample tables created successfully")
    
    def insert_sample_data(self):
        """
        Insert sample data into tables A and B for testing.
        """
        cursor = self.connection.cursor()
        
        # Sample data for table A
        table_a_data = [
            (1, 'apple', 'red'),
            (2, 'banana', 'yellow'),
            (3, 'cherry', 'red'),
            (4, 'date', 'brown'),
            (5, 'elderberry', 'purple')
        ]
        
        # Sample data for table B (some overlap with table A)
        table_b_data = [
            (1, 'apple', 'red'),
            (3, 'cherry', 'red'),
            (6, 'fig', 'purple'),
            (7, 'grape', 'green')
        ]
        
        cursor.executemany("INSERT OR REPLACE INTO table_a (id, name, value) VALUES (?, ?, ?)", table_a_data)
        cursor.executemany("INSERT OR REPLACE INTO table_b (id, name, value) VALUES (?, ?, ?)", table_b_data)
        
        self.connection.commit()
        logger.info("Sample data inserted successfully")
    
    def find_data_not_in_table_b(self, key_columns: List[str] = None) -> List[Tuple[Any, ...]]:
        """
        Find data that exists in table_a but not in table_b.
        
        Args:
            key_columns (List[str]): List of column names to use for comparison.
                                   If None, uses all columns except id.
        
        Returns:
            List[Tuple]: List of tuples representing rows that exist in A but not in B.
        """
        if key_columns is None:
            key_columns = ['name', 'value']
        
        # Build the WHERE clause for comparison
        where_conditions = []
        for col in key_columns:
            where_conditions.append(f"a.{col} = b.{col}")
        
        where_clause = " AND ".join(where_conditions)
        
        query = f"""
            SELECT a.*
            FROM table_a a
            LEFT JOIN table_b b ON {where_clause}
            WHERE b.{key_columns[0]} IS NULL
            ORDER BY a.id
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        
        logger.info(f"Found {len(results)} records in table_a but not in table_b")
        return [tuple(row) for row in results]
    
    def find_data_not_in_table_a(self, key_columns: List[str] = None) -> List[Tuple[Any, ...]]:
        """
        Find data that exists in table_b but not in table_a.
        
        Args:
            key_columns (List[str]): List of column names to use for comparison.
                                   If None, uses all columns except id.
        
        Returns:
            List[Tuple]: List of tuples representing rows that exist in B but not in A.
        """
        if key_columns is None:
            key_columns = ['name', 'value']
        
        # Build the WHERE clause for comparison
        where_conditions = []
        for col in key_columns:
            where_conditions.append(f"b.{col} = a.{col}")
        
        where_clause = " AND ".join(where_conditions)
        
        query = f"""
            SELECT b.*
            FROM table_b b
            LEFT JOIN table_a a ON {where_clause}
            WHERE a.{key_columns[0]} IS NULL
            ORDER BY b.id
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        
        logger.info(f"Found {len(results)} records in table_b but not in table_a")
        return [tuple(row) for row in results]
    
    def get_table_contents(self, table_name: str) -> List[Tuple[Any, ...]]:
        """
        Get all contents of a specified table.
        
        Args:
            table_name (str): Name of the table to query.
        
        Returns:
            List[Tuple]: All rows in the table.
        """
        cursor = self.connection.cursor()
        cursor.execute(f"SELECT * FROM {table_name} ORDER BY id")
        results = cursor.fetchall()
        return [tuple(row) for row in results]


def main():
    """
    Main function to demonstrate the FDB query functionality.
    """
    print("=== FDB Query Demo ===")
    print("Finding data that exists in table A but not in table B\n")
    
    # Initialize FDB Query
    fdb = FDBQuery()
    
    try:
        # Create tables and insert sample data
        fdb.create_sample_tables()
        fdb.insert_sample_data()
        
        # Display table contents
        print("Table A contents:")
        table_a_data = fdb.get_table_contents("table_a")
        for row in table_a_data:
            print(f"  {row}")
        
        print("\nTable B contents:")
        table_b_data = fdb.get_table_contents("table_b")
        for row in table_b_data:
            print(f"  {row}")
        
        # Find data in A but not in B
        print("\nData in Table A but NOT in Table B:")
        diff_results = fdb.find_data_not_in_table_b()
        if diff_results:
            for row in diff_results:
                print(f"  {row}")
        else:
            print("  No differences found")
        
        # Find data in B but not in A
        print("\nData in Table B but NOT in Table A:")
        diff_results_reverse = fdb.find_data_not_in_table_a()
        if diff_results_reverse:
            for row in diff_results_reverse:
                print(f"  {row}")
        else:
            print("  No differences found")
            
    finally:
        fdb.close()


if __name__ == "__main__":
    main()