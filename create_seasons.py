#!/usr/bin/env python

"""
Generate a given number of one month seasons.

Use the `-n <nb of seasons to add>` to specify the number of
seasons to add.

Author: Sarrus - September 2022
"""

import mysql.connector
import os
from datetime import datetime
import argparse
from dotenv import load_dotenv


def main(seasons_to_add: int):
    current_month = datetime.now().month
    current_year = datetime.now().year
    last_id = 0
    with mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        passwd=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME")
    ) as db:
        cursor = db.cursor()
        cursor.execute(
            "SELECT * FROM rankme_season_id WHERE season_id = ( SELECT MAX(season_id) FROM rankme_season_id );")
        res = cursor.fetchone()
        if res is not None:
            last_id = int(res[0])
            current_month = res[2].month
            current_year = res[2].year
        for i in range(last_id+1, last_id+1+seasons_to_add):
            start_date = datetime(current_year, current_month, 1, 0, 0, 1)
            current_month += 1
            if current_month > 12:
                current_month = 1
                current_year += 1
            end_date = datetime(current_year, current_month, 1, 0, 0, 0)
            cursor.execute(
                f"INSERT INTO `rankme_season_id` (`season_id`, `start_date`, `end_date`) VALUES ('{i}', '{start_date.isoformat()}', '{end_date.isoformat()}');")
        db.commit()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-n', '--number', help="Number of seasons to add.", default=0, type=int)
    args = parser.parse_args()

    load_dotenv()

    main(args.number)
