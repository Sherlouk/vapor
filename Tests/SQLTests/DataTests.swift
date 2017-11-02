import SQL
import XCTest

final class DataTests: XCTestCase {
    func testBasicSelectStar() {
        let select = DataQuery(statement: .select, table: "foo")
        XCTAssertEqual(
            GeneralSQLSerializer.shared.serialize(data: select),
            "SELECT `foo`.* FROM `foo`"
        )
    }

    func testSelectWithPredicates() {
        var select = DataQuery(statement: .select, table: "foo")

        let predicateA = DataPredicate(
            column: DataColumn(name: "id"),
            comparison: .equal,
            value: .placeholder
        )
        select.predicates.append(predicateA)

        let predicateB = DataPredicate(
            column: DataColumn(table: "foo", name: "name"),
            comparison: .equal,
            value: .placeholder
        )
        select.predicates.append(predicateB)

        XCTAssertEqual(
            GeneralSQLSerializer.shared.serialize(data: select),
            "SELECT `foo`.* FROM `foo` WHERE `id` = ? AND `foo`.`name` = ?"
        )
    }

    func testSelectWithJoins() {
        var select = DataQuery(statement: .select, table: "foo")

        let joinA = Join(method: .inner, table: "foo", column: "id", foreignTable: "bar", foreignColumn: "foo_id")
        select.joins.append(joinA)

        XCTAssertEqual(
            GeneralSQLSerializer.shared.serialize(data: select),
            "SELECT `foo`.* FROM `foo` JOIN `bar` ON `foo`.`id` = `bar`.`foo_id`"
        )
    }
}
