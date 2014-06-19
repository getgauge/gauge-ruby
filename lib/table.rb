
class GaugeTable
    def initialize(protoTable)
        @columns = protoTable.headers.cells
        @rows = []
        protoTable.rows.each do |row|
            @rows.push row.cells
        end
    end

    def columns
        @columns
    end

    def rows
        @rows
    end
end
